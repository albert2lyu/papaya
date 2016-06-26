#ifndef UDP_H
#define UDP_H
#pragma pack(push)
#pragma pack(1)

struct udphdr{
	u16 myport;	
	u16 yourport;
	u16 len;
	u16 checksum;
};

#pragma pack(pop)
#endif
