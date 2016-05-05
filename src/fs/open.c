#include<linux/fs.h>

/* 功能要完整实现，例如对rlimits的支持，但为了代码简单，会选择牺牲效率。例如不用bitmap。
 */
static int get_unused_fd(void){
	struct files_struct *files = current->files;
	int i;
	for(i = 0; i < files->max_fds; i++){
		if(files->filep[i] == 0){
			files->filep[i] = (void *)1;
			return i;
		}
	}
	/* used out. */
	int new_max = files->max_fds * 2;
	if(new_max > current->rlimits[RLIMIT_NOFILE].cur) return -1;
	/* realloc. double it*/
	struct file **filep = kmalloc(4 * new_max);
	memcpy(filep, files->filep, 4 * files->max_fds);
	files->max_fds = new_max;
	if(files->filep == files->__file_array) kfree(files->filep);
	files->filep = filep;

	return i;	
}

/* @mode specifys the permission to use when a new file is created, if neither O_CREAT or 
 * O_TMPFILE is specified, then @mode is ignored.
 */
int sys_open(char *path, unsigned flags, unsigned mode){
	struct in_dir indir;
	int err;
	err = pathwalk(path, &indir, 0);
	if(err) return -1;

	int fd = get_unused_fd();
	if(fd == -1) return -1;

	
	struct file *file = kmalloc( sizeof(struct file) );
	file->dentry = indir.dentry;
	file->pos = 0;
	file->count = 1;
	file->flags = flags;
	file->data = 0;
	current->files->filep[fd] = file;

	/* change encode flavor 
	 * O_RDONLY 00 ==> 01
	 * O_WRONLY 01 == > 10 
	 * O_RDWR   10 == > 11
	 */
	file->mode = (flags + 1) & 3;	/* &3是确保只取低两位*/


	return 0;
}














