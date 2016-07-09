#include<linux/printf.h>
#include<mm.h>
#include<video_drv.h>

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
#pragma pack(push)
#pragma pack(1)
struct cell{
	union{
		struct{
			char ascii;
			char mod;
		};
		u16 value;
	};
};
#pragma pack(pop)
#define video_mem ((char *)0xc00b8000)
struct cell *video_cells = (void *)video_mem;
/* printf函数依赖于页分配函数，在mm初始化之前，只好从栈上取内存用 */
int printf(char *format, ...){
	int oldline = -1;
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
	//TODO 若line nr不变，不调用open_window.
	open_window(POS_L(cursor) - PAGE_H + 1 + 4);
	if(IF) sti();
	if(mm_available){
		kfree_pg(buf, BUF_PG_ORDER);
	}
	return length;
}

static void clearline(int l){
	struct cell *o = &video_cells[ l * PAGE_W ];
	for(int i = 0; i < PAGE_W; i++){
		o[i].ascii = 0;
	}
}

static void open_window(int startline){
	if(startline < 0) startline = 0;
	set_start(startline * PAGE_W);	
}
