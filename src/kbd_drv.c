/**
 * our keyboard driver works in a extremely simple way. she just reads port
 * 0x60 when a key is pressed or released,produces an ascii code or special
 * code, and pushs the code to the private keyboard-buffer of a process who
 * is sleeping on MSGTYPE_CHAR.
 * FIXME the driver will be tired of pushing key-code when too many processes
 * are sleeping on MSGTYPE_CHAR,can we make the keyboard-buffer shared by all
 * processes ?
 */
#include<kbd_drv.h>
#include<utils.h>
#include<proc.h>
extern struct pcb **pcb_lists[3];
/* Keymap for US MF-2 keyboard. */
unsigned char keymap[NR_SCAN_CODES * MAP_COLS]   = {
	/* scan-code !Shift Shift E0 XX */
	/* ==================================================================== */
	/* 0x00 - none */ 0, 0, 0,
	/* 0x01 - ESC */ ESC, ESC, 0,
	/* 0x02 - '1' */ '1', '!', 0,
	/* 0x03 - '2' */ '2', '@', 0,
	/* 0x04 - '3' */ '3', '#', 0,
	/* 0x05 - '4' */ '4', '$', 0,
	/* 0x06 - '5' */ '5', '%', 0,
	/* 0x07 - '6' */ '6', '^', 0,
	/* 0x08 - '7' */ '7', '&', 0,
	/* 0x09 - '8' */ '8', '*', 0,
	/* 0x0A - '9' */ '9', '(', 0,
	/* 0x0B - '0' */ '0', ')', 0,
	/* 0x0C - '-' */ '-', '_', 0,
	/* 0x0D - '=' */ '=', '+', 0,
	/* 0x0E - BS */ BACKSPACE, BACKSPACE, 0,
	/* 0x0F - TAB */ TAB, TAB, 0,
	/* 0x10 - 'q' */ 'q', 'Q', 0,
	/* 0x11 - 'w' */ 'w', 'W', 0,
	/* 0x12 - 'e' */ 'e', 'E', 0,
	/* 0x13 - 'r' */ 'r', 'R', 0,
	/* 0x14 - 't' */ 't', 'T', 0,
	/* 0x15 - 'y' */ 'y', 'Y', 0,
	/* 0x16 - 'u' */ 'u', 'U', 130,
	/* 0x17 - 'i' */ 'i', 'I', 0,
	/* 0x18 - 'o' */ 'o', 'O', 0,
	/* 0x19 - 'p' */ 'p', 'P', 0,
	/* 0x1A - '[' */ '[', '{', 0,
	/* 0x1B - ']' */ ']', '}', 0,
	/* 0x1C - CR/LF */ ENTER, ENTER, 0,
	/* 0x1D - l. Ctrl */ CTRL_L, CTRL_L, CTRL_R,
	/* 0x1E - 'a' */ 'a', 'A', 0,
	/* 0x1F - 's' */ 's', 'S', 0,
	/* 0x20 - 'd' */ 'd', 'D', 131,
	/* 0x21 - 'f' */ 'f', 'F', 0,
	/* 0x22 - 'g' */ 'g', 'G', 0,
	/* 0x23 - 'h' */ 'h', 'H', 0,
	/* 0x24 - 'j' */ 'j', 'J', 0,
	/* 0x25 - 'k' */ 'k', 'K', 0,
	/* 0x26 - 'l' */ 'l', 'L', 128,
	/* 0x27 - ';' */ ';', ':', 0,
	/* 0x28 - '\'' */ '\'', '"', 0,
	/* 0x29 - '`' */ '`', '~', 0,
	/* 0x2A - l. SHIFT */ SHIFT_L, SHIFT_L, 0,
	/* 0x2B - '\' */ '\\', '|', 0,
	/* 0x2C - 'z' */ 'z', 'Z', 0,
	/* 0x2D - 'x' */ 'x', 'X', 0,
	/* 0x2E - 'c' */ 'c', 'C', 129,
	/* 0x2F - 'v' */ 'v', 'V', 0,
	/* 0x30 - 'b' */ 'b', 'B', 0,
	/* 0x31 - 'n' */ 'n', 'N', 0,
	/* 0x32 - 'm' */ 'm', 'M', 0,
	/* 0x33 - ',' */ ',', '<', 0,
	/* 0x34 - '.' */ '.', '>', 0,
	/* 0x35 - '/' 		*/	'/',		'?',		0,
	/* 0x36 - r. SHIFT	*/	SHIFT_R,	SHIFT_R,	0,
	/* 0x37 - '*'		*/	'*',		'*',    	0,
	/* 0x38 - ALT		*/	ALT_L,		ALT_L,  	ALT_R,
	/* 0x39 - ' '		*/	' ',		' ',		0,
};

static int ctrl_down=0;
static int shift_down=0;
void  key_handler(void){
	/**pressing down 'ctrl' and 'shift' simultaneously is forbidden,no reason*/
	assert(!(ctrl_down&&shift_down))
	int key_code=in_byte(0x60);
	oprintf("*");
	/*update the mode of key-ctrl and key-shift to variables 'ctrl_down' and 'shift_down' when pressed or release*/
	if(key_code>=NR_SCAN_CODES){
		(key_code==BC_CTRL_L)?ctrl_down=0:0;
		(key_code==BC_SHIFT_L||key_code==BC_SHIFT_R)?shift_down=0:0;
	}
	else if(key_code==MC_CTRL_L){
		ctrl_down=1;
	}
	else if(key_code==MC_SHIFT_L||key_code==MC_SHIFT_R){
		shift_down=1;
	}
	/**end update*/

	/**handle common keys,'a','b','c'..*/
	else{
		/**the core operation of keyboard driver.
		 * convert scan-code to key-code(ascii or special code).
		 */
		//unsigned ascii=keymap[key_code*MAP_COLS+shift_down*1+ctrl_down*2];
		/**wake process sleeping on MSGTYPE_CHAR and pass her a keycode*/
		struct pcb *curr;
		for(int i = 0; i < 3; i++){
			curr = *pcb_lists[i];
			while(curr){
				//obuffer_push(&curr->obuffer, ascii);
				/**FIXME check within list_sleep here?*/
				if(curr->msg_type == MSGTYPE_CHAR){	
/*					oprintf("wake wait-char process\n");*/
					sleep_active(curr);
				}
				curr = curr->next;
			}
		}
		/**
		for(int pid=0;pid<MAX_TASK;pid++){
			if(pcb_table[pid].mod==TASKMOD_SLEEP&&pcb_table[pid].msg_type==MSGTYPE_CHAR){
				SLEEP_ACTIVE(pid);
				obuffer_push(&pcb_table[pid].obuffer,ascii);
			}
		}
		 */
	}
	/**yes,we must call proc_dispatch immediately because key-event is urgent.
	 * delay for a timeslice(1~10ms) is intolerable.
	 */
	schedule();
}
