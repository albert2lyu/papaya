#include<linux/resource.h>
#include<linux/mylist.h>
#include<linux/mm.h>
#include<proc.h>
#include<old/schedule.h>
#include<linux/wait.h>

void do_exit(long code);

long sys_exit(int errcode){
	do_exit( (errcode & 0xff) << 8);
	return 0;
}

/* 进程退出之后，还保留着8K的task page和4K的页目录。
 * 我不知道linux是怎么做的，但保留页目录，编程方便很多。
 */
void do_exit(long code){
	struct mm *mm;

	mm = current->mm;
	assert(mm);
	
	try_release_user_space(mm);
	try_release_krnl_resource(current);
	LL_DEL(list_active, current);
	current->exit_status = code;
	current->state = TASK_ZOMBIE;

	schedule();
}

static int release_task_page(struct pcb *pcb){
	__free_pages((void *)pcb, 1);
	return 0;
}

//托孤
static int adopt_his_children(struct pcb *he){
	struct pcb *child;
	list_for_each_safe(&he->children, child, sibling){
		child->monitor = task1;
		list_add(&child->sibling, &task1->children);
	}
	return 0;
}

//脱离关系网
static int pickup_from_network(struct pcb *task){
	list_del(&task->sibling);	
	return 0;
}

long sys_wait4(int pid, unsigned  *status, int options, struct rusage *ru){
	struct pcb *child;
	long ret = -1;

	repeat:
	list_for_each_safe(&current->children, child, sibling){
		if(pid != -1 ){
			if(pid != child->pid) continue;
			/* POSIX:	FIXME when pid is -1 ..
			   if WNOHANG was specified and one or more child(ren) speci‐
			   fied by pid exist, but have not yet changed state, then 0 is  
			   returned.
			 */
			if(options == WNOHANG)
				ret = 0;	
		}

		if(child->state != TASK_ZOMBIE) 	continue;

		ret = child->pid;
		if(status)	*status = child->exit_status;

		put_mm(child->mm);
		child->mm = 0;
		adopt_his_children(child);
		pickup_from_network(child);
		release_task_page(child);
		goto out;
	}
	if(options == WUNTRACED)	goto repeat;
	else if(options == WNOHANG);
	else spin("bad wait options");

	out:
	return ret;
}











