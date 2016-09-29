#include<linux/fs.h>
#include<linux/errno.h>

static int do_lseek(struct file *file, int offset, unsigned origin){
	switch(origin){
		case 1:
			offset += file->pos;
			break;
		case 2:
			offset += file->dentry->inode->size;
	}
	if(offset < 0) return -EINVAL;
	//if(offset > ..)		//'hole' operation not implemented yet
	file->pos = offset;

	return offset;
}
/*
  @origin 
  SEEK_END:	The offset is set to the size of the file plus offset bytes.
 */
int sys_lseek(unsigned fd, int offset, unsigned origin){
	struct file *file = fcheck(fd);
	offset =  do_lseek(file, offset, origin);
	if(offset < 0) {
		return -1;
		//errno = offset;
	}
	return offset;
}

static int do_close(struct file *file){
	
	struct file_operations *fops = file->dentry->inode->file_ops;
	if(fops->onclose) fops->onclose(file);

	if(--file->count == 0){		/* close, step 2 */
		kfree(file);	
	}
	return 0;
}
/* mainly do two jobs:
 * 1, set correspoding slot in current->filep[] to 0
 * 2, decrement the 'count' field of corresponding 'file' structure 
 */
int sys_close(unsigned fd){
	int ret;
	if(current->files->max_fds <= fd) return -EINVAL;
	if( current->files->filep[fd] == 0) return -EINVAL;	/* attempt to close a file not 
														 * opened yet */

	struct file *file = current->files->filep[fd];
	ret = do_close(file);
	current->files->filep[fd] = 0;
	return ret;
}


//这样一个接口，内核稍微分装一下，可以对外当做系统调用, sys_xx; 对内自己用, k_xx
static int do_read(struct file *file, char *buf, unsigned size){
	if(!file) return -EBADF;
	if(!(file->mode & FMODE_READ))	return -EACCES;

	unsigned filesize = file->dentry->inode->size;
	if(file->pos + size > filesize) size = filesize - file->pos;
	int ret = file->dentry->inode->file_ops->read(file, buf, size, 0);
	return ret;
}
int sys_read(unsigned fd,  char *buf, unsigned size){
	int bytes_r;
	struct file *file = fcheck(fd);
	bytes_r =  do_read(file, buf, size);
	if(bytes_r < 0){
		//errno = bytes_r;
		return -1;
	}
	return bytes_r;
}

//k_打头的，都是直接供内核调用的，且不经过syscall。否则用kernel_打头
//这些函数不会设置errno。它们的返回值目前也比较bare。暂时不考虑跟系统调用保持一致。
//TODO 不应该通过sys_open,不应该leave footprint on current->filep[]
struct file * k_open(char *path, ulong flags, ulong mode){
	int fd = sys_open(path, flags, mode);
	return fget(fd);
}

int k_read(struct file *file, char *buf, unsigned size){
	return do_read(file, buf, size);
}


int k_seek(struct file *file, int offset, unsigned origin){
	return do_lseek(file, offset, origin);	
}

int k_close(struct file*file){
	return do_close(file);
}

