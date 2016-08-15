/* 注意，stat_wnd用x,y来定位bar。其中x是列，y是行！！！
 *     ,  另外，stat_wnd的第一行用来当分割线。所以所有的y都指向y+1行。TODO
 * TODO 1, 用assert代替while(1)。
 *      2, 怎样确保 mm_available在外部忘了初始化，这里能检测出来。限制栈分配
 *     		内存的次数？
 */
#include<linux/printf.h>
#include<mm.h>
#include<video_drv.h>


static void statwnd_render(void);
static void open_window(int starline);
static void clearline(int l);
//////////////////////////////////////////////////
//目前printf使用的是尽量安全的方式。申请16KB的页当做”写前缓存“。
//但mm初始化之前，使用栈上分配。
/////////////////////////////////////////////////
bool mm_available = false;
bool task_available = false;

int cursor;

#define BUF_PG_ORDER 2
#define PAGE_W 80
#define PAGE_H 25
#define O_PER_PAGE (PAGE_W * PAGE_H)
#undef PAGE_SIZE
#define PAGE_SIZE (O_PER_PAGE * 2)
#define NR_PAGES 8
#define VIDEO_CELL_NUM (O_PER_PAGE * NR_PAGES)
#define VIDEO_BUF_SIZE (PAGE_SIZE * NR_PAGES)

#define POS_L(pos) (pos / PAGE_W)
#define VIDEO_L_ADDR(lineid) (video_cells + (lineid )* PAGE_W)

#define RGB_BLUE 1
#define RGB_GREEN 2
#define RGB_RED 4
#define RGB_WHITE 7

#pragma pack(push)
#pragma pack(1)
struct colormod{
	union{
		struct{
			int fg: 3;
			bool highlight:1;
			int bg: 3;
			bool blink:1;
		};
		char value;
	};
};

struct cell{
	union{
		struct{
			char ascii;
			struct colormod mode;
		};
		u16 value;
	};
};
#pragma pack(pop)
#define video_mem ((char *)0xc00b8000)
struct cell *video_cells = (void *)video_mem;

//////////////////////////////////////////////////////////////////////////////
// Status Window
// We reserve several bottom lines on screen as 'status window'
//////////////////////////////////////////////////////////////////////////////
#define STAT_WND_H 4
#define STAT_WND_SIZE (STAT_WND_H * PAGE_W * 2)
struct cell stat_wnd[STAT_WND_H][PAGE_W];

/* printf函数依赖于页分配函数，在mm初始化之前，只好从栈上取内存用 */
int oprintf(char *format, ...){
	int oldline;
	int IF;
	size_t upsize = mm_available ? 0: 1024;
	char stkroom[upsize];
	/* four pages, 16K */
	char *buf = mm_available ? kmalloc_pg(0, BUF_PG_ORDER) : stkroom;
	char *read = buf;

	int length = __sprintf(buf, format, (u32 *)(&format + 1));
	if(length > 80 * 24) while(1);
	/* 整个写屏期间必须关中断，因为没办法一次性调整cursor：会涉及到\t,\b,\n
	 */
	IF = cli_ex();

	while(*read){
		oldline = POS_L(cursor);
		if(*read == '\n'){			//Enter
			cursor = (cursor / PAGE_W + 1) * PAGE_W;
		}
		else if(*read == '\t'){		//Tab width = 4
			cursor += 4;	
		}
		else{
			video_cells[cursor].ascii = *read;
			video_cells[cursor].mode.fg = RGB_WHITE;
			cursor++;
		}

		if(cursor >= VIDEO_CELL_NUM){
			memcpy(video_mem, video_mem + (NR_PAGES - 1) * PAGE_SIZE, PAGE_SIZE);
			cursor = cursor % O_PER_PAGE + O_PER_PAGE;
		}
		int currline = POS_L(cursor);
		if(currline != oldline) clearline(currline);
		read++;
	}

	statwnd_render();
	//TODO 若line nr不变，不调用open_window.
	open_window(POS_L(cursor) - PAGE_H + 1 + 4);
	if(IF) sti();
	if(mm_available){
		kfree_pg((unsigned)buf, BUF_PG_ORDER);
	}
	return length;
}

static void statwnd_render(void){
	memcpy(VIDEO_L_ADDR( POS_L(cursor) + 1), stat_wnd, STAT_WND_SIZE);
}
static void clearline(int l){
	struct cell *o = &video_cells[ l * PAGE_W ];
	for(int i = 0; i < PAGE_W; i++){
		o[i].value = 0;
	}
}

static void open_window(int startline){
	if(startline < 0) startline = 0;
	set_start(startline * PAGE_W);	
}




//////////////////////////////////////////////////////////////////////////////
// Status Window
// We reserve several bottom lines on screen as 'status window'
//////////////////////////////////////////////////////////////////////////////
#define BAR_V_NR 3			//verticle
#define BAR_H_NR 3			//horizental
#define BAR_NR (BAR_V_NR * BAR_H_NR)
#define SIDE_EDGE_WIDTH 2
#define BAR_CELLS ((PAGE_W - SIDE_EDGE_WIDTH * 2) / BAR_H_NR)
#define BAR_SIZE (BAR_CELLS * 2)
//第一行被用来当分割线。
#define BAR(x, y) (stat_wnd[y + 1] + SIDE_EDGE_WIDTH + BAR_CELLS * x)

struct bar_desc{
	struct colormod mode;
	char *title;
};
static struct bar_desc desc_of_bar[BAR_V_NR][BAR_H_NR];
static void __set_column(struct cell *wnd, int col, 
					int beginl, int lnum, struct cell cell){
	for(int i = beginl; i < beginl + lnum; i++)	{
		memcpy(wnd + i * PAGE_W + col, &cell, sizeof(struct cell));
	}
}

static void statwnd_setcol(int col, struct cell cell){
	__set_column(stat_wnd[0], col, 0, 4, cell);
}

static void  __set_line(struct cell *wnd, int line,
				  int begin, int columns, struct cell cell){
	for(int i = begin; i < begin + columns; i++){
		memcpy(wnd + line * PAGE_W + i, &cell, sizeof(struct cell));		
	}
}

static void statwnd_setline(int line, struct cell cell){
	__set_line(stat_wnd[0], line, 0, PAGE_W, cell);
}
	
/* return the length of @str */
static int write_screen(struct cell *start, char *str,  struct colormod mode){
	char *read = str;
	struct cell *write = start;
	while(*read){
		write->ascii = *read;
		write->mode.value = mode.value;

		write++;
		read++;
	}
	return read - str;
}

void write_bar(int x, int y, char *title, char *content){
	if(x > 2 || y > 2) while(1);
	struct bar_desc *desc = &desc_of_bar[x][y];
	if(title){
		desc->title = title;	
	}
	if(!content) content = "nul";

	struct cell *bar_start = BAR(x, y);
	int offset = 0;
	offset  = write_screen(bar_start + offset, desc->title, desc->mode);
	write_screen(bar_start + offset, content, desc->mode);
	statwnd_render();
}


void init_status_window(void){
	struct cell blue_cell = { ascii:0, mode: {bg:RGB_BLUE} };
	statwnd_setcol(0, blue_cell);
	statwnd_setcol(1, blue_cell);
	statwnd_setcol(PAGE_W - 1, blue_cell);
	statwnd_setcol(PAGE_W - 2, blue_cell);

	statwnd_setline(0, blue_cell);

	for(int i = 0; i < BAR_V_NR; i++){
		for(int j = 0; j < BAR_H_NR; j++){
			desc_of_bar[i][j].mode.bg = RGB_GREEN;
			desc_of_bar[i][j].mode.fg = RGB_RED;
			desc_of_bar[i][j].mode.blink = false;
			desc_of_bar[i][j].mode.highlight = false;

			desc_of_bar[i][j].title = "?:";
		}
	}
}

void init_display(void){
	init_status_window();

}















