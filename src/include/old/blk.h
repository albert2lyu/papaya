#ifndef BLK_H
#define BLK_H

/* 1, it seems that all requests of all block devices can be descriped with
*  this structure.
*/
struct request{
	int dev;
	int cmd;
	unsigned lba;
	int count;
	char *buffer;	
}
#endif
