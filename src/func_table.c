#include<utils.h>
#include<disp.h>
#include<proc.h>
#include<fs.h>
//eax=0,写屏函数，在disp.c里
//对void k_show_chars(char*pt_head,unsigned var_type)的包装
void _k_show_chars(char*pt_head,unsigned end_flag){
	//k_show_chars(pt_head,end_flag);
}
//eax=1,阻塞函数，使当前进程进入休眠，并放弃时间片
//far-away
void k_sleep(int msg_type,int msg_bind){
/*	oprintf("%s msg_type:%x,msg_bind:%x\n", current->p_name,msg_type, msg_bind);*/
/*	oprintf("eax:%x,ebx:%x,ecx:%x,edx:%x",  current->regs.eax, current->regs.ebx, current->regs.ecx, current->regs.edx);*/
	active_sleep(current,msg_type,msg_bind);
	schedule();
}

/**
//eax=2
int k_obuffer_shift(void){
	int shift_result=obuffer_shift(&pcb_table[pcb_table_info.curr_pid].obuffer);
	SET_PID_EAX(pcb_table_info.curr_pid,shift_result);
	fire(pcb_table_info.curr_pid);//直接返还到调用者，不做进程调度
	return 0;//这条return函数只是摆设，返回值早已写到pcb里
}
//eax=3
//包装了void k_show_var(unsigned var,unsigned var_type);在屏幕上打印一个类型变量，定义在disp.c
void _k_show_var(unsigned var,unsigned var_type){
	k_show_var(var,var_type);
	fire(pcb_table_info.curr_pid);//直接返还到调用者，不做进程调度
}

*/
//eax=4
#if 0
void k_open(char*path,int mod){
/*	askfs(COMMAND_OPEN,path,0,0,0,0,0,0);*/
}
//eax=5
void k_read(int fd,char*buf,int size){
/*	askfs(COMMAND_READ,0,0,fd,buf,size,0,0);*/
}
//eax=6
void k_write(void){

}
//eax=7
void k_close(void){
/*	askfs(COMMAND_CLOSE,0,0,fd,0,0,0,0);*/
}
//eax=8		attention:kernel-process need this syscall,for they live in ring1 and can not touch dr0~7
void k_watch(u32 addr,int write_only){
//	debug_watch(addr,write_only);
	//fire(pcb_table_info.curr_pid);
}
void k_seek(int fd,int offset,int whence){
/*	askfs(COMMAND_SEEK,0,0,fd,0,0,offset,whence);*/
}
#endif



/**进程陷入内核就一定会被休眠吗*/
/**d这是一个异步的getchar,按键缓冲区空直接返回-1*/
int k_getchar(void){
	//int ascii;
	//if((ascii=obuffer_shift(&current->obuffer))==0) ascii = -1;
/*	oprintf("k_getchar return:%x\n", ascii);*/
/*	syscall_ret(ascii, -1);	*/
	spin("bad sys_call_ret");
	return 0;
}








