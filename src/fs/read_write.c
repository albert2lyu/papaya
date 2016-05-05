#include<linux/fs.h>
#include<linux/errno.h>

/*
  @origin 
  SEEK_END:	The offset is set to the size of the file plus offset bytes.
 */
int sys_lseek(unsigned fd, int offset, unsigned origin){
	if(fd >= current->files->max_fds) return -EINVAL;

	struct file *file = current->files->filep[fd];
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

/* mainly do two jobs:
 * 1, set correspoding slot in current->filep[] to 0
 * 2, decrement the 'count' field of corresponding 'file' structure 
 */
int sys_close(unsigned fd){
	if(current->files->max_fds <= fd) return -EINVAL;
	if( current->files->filep[fd] == 0) return -EINVAL;	/* attempt to close a file not 
														 * opened yet */

	struct file *file = current->files->filep[fd];
	current->files->filep[fd] = 0;		/* close, step 1 */
	
	struct file_operations *fops = file->dentry->inode->file_ops;
	if(fops->onclose) fops->onclose(file);

	if(--file->count == 0){		/* close, step 2 */
		kfree(file);	
	}
	return 0;
}


int sys_read(unsigned fd,  char *buf, unsigned size){
	struct file *file = fcheck(fd);
	if(!file) return -EBADF;
	if(!(file->mode & FMODE_READ))	return -EACCES;

	unsigned filesize = file->dentry->inode->size;
	if(file->pos + size > filesize) size = filesize - file->pos;
	int ret = file->dentry->inode->file_ops->read(file, buf, size, 0);
	return ret;
}





