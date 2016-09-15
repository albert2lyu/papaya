#ifndef IDE_H
#define IDE_H
#include<linux/blkdev.h>

#define WIN_READ 0x20
#define WIN_WRITE 0x30

#define IDE_NR_PORTS 255
#define MAX_DRIVES 2

//indication of 8-bit status register
#define STATUS_ERR 1
#define STATUS_INDEX 2
#define STATUS_ECC 4
#define STATUS_DRQ 8
#define STATUS_SEEK 16
#define STATUS_WRERR 32
#define STATUS_READY 64
#define STATUS_BUSY 128

#define REG_DATA (0x1f0)

#define REG_ERROR (0X1F1)
#define REG_FEATURES (0X1F1)

#define REG_COUNT (0X1F2)
#define REG_LBA_LOW (0X1F3)
#define REG_LBA_MID (0X1F4)
#define REG_LBA_HIGH (0x1F5)
#define REG_DEVICE (0X1F6)

#define REG_STATUS (0x1F7)
#define REG_COMMAND (0x1F7)

#define REG_CONTROL (0X3F6)
enum{
	SLOT_REG_DATA,	
	SLOT_REG_FEATURES,
	SLOT_REG_COUNT,
	SLOT_REG_LBA_LOW,
	SLOT_REG_LBA_MID,
	SLOT_REG_LBA_HIGH,
	SLOT_REG_DEVICE,
	SLOT_REG_COMMAND,

	SLOT_REG_CONTROL,
	SLOT_REG_STATUS = SLOT_REG_COMMAND,
	SLOT_REG_ERROR = SLOT_REG_FEATURES,
};

/*---------------------------------------------------
  |  1  | LBA/CHS  | 1  |  DRV  |    |    |    |    |
  ---------------------------------------------------
*/
struct select{
	u8 head: 4;	/* always 0 here, why? */
	u8 drv: 1;	/* master:0  or slave:1 */
	u8 bit5: 1;	/* always 1*/
	u8 lba: 1;	/* CHS:0 LBA:1*/
	u8 bit7: 1;	/* always 1 */
};
struct lba{
	u8 low;
	u8 middle;
	u8 high;
	struct select select;
};


struct ide_drive{
	struct request_queue queue;		/*one for each disk*/
	unsigned present: 1;
};

struct ide_hwif{
	int io_ports[IDE_NR_PORTS];
	struct ide_drive drive[MAX_DRIVES];
	struct request *cur_rq;		/*current request*/
	void (*handler)(struct ide_hwif *);
};

void ide_init(void);
void ide_read_partation(int major, int drive);
#endif
