#ifndef __NTFS_H__
#define __NTFS_H__

#include <valType.h>


/* ntfs header struct 
 * pack(1) make the ntfs header struct aligned by byte so we don't have to count the offset.
 * */
/*#pragma pack(push,1)*/

typedef u16 WCHAR;
#define MAX_PATH                260

#pragma pack(1)
typedef struct	tag_NTFS_header{
    byte    bJmp[3];	    //jmp
    byte    bNTFlags[4];    // �ļ�ϵͳNTFS��Ϊ "NTFS"
    byte    bReserve1[4];   //һ��Ϊ�ĸ��ո�	
    short    wBytePerSector; //ÿ�����ֽ���	
    byte    bSectorPerCluster;//;ÿ��������
    short    wReserveSectors;//����������
    byte    bFatNum;	 // ����0
    short    wRootDirNum;	 //���� 0	
    short    wSectorOfParti; //����0
    byte    bMedium;//
    short    wSectorPerFat;	    //����0	
    short    wSectorPerTrack;   //	
    short    wHeadNum;//
    unsigned int   dwHideSector;//
    unsigned int   dwSectoOfParti; //����0
    byte    bDeviceFlag;//	
    byte    bReserve2;//
    short    wReserve3;//	
    uint64_t	ullSectorsOfParti;//��������
    uint64_t	ullMFTAddr;//$MFT����ʼ�߼��غ�
    uint64_t	ullMFTMirrAddr;// $MFTMirr����ʼ�߼��غ�
    byte	bClusterPerFile;//
    byte	bReserve4[3];//
    unsigned int dwClusterPerINDX;//
    byte	bSerialID[8];//
} ntfs_header, *pntfs_header;
/*restore default aligin settings*/

/*#pragma pack(pop,1)*/

typedef struct tag_MFTHEAD {
	byte bHeadID[4];//MFT��־��һ��ΪFILE
	u16 usFixupOffset;//�������кŵ�ƫ��
	u16 usFixupNum;//�������кŵĴ�С
	byte bReserve1[8];//
	u16 wUnknownSeqNum; //
	u16 usLinkNum;//
	u16 usAttrOffset;//��һ�����Ե�ƫ�Ƶ�ַ
	short wResident;//	�ļ����Ա�־
	unsigned long ulMFTSize;//�ļ���¼��ʵ�ʳ���
	unsigned long ulMFTAllocSize;//��¼����Ĵ�С
	uint64_t ullMainMFT;//�����ļ���¼���ļ�������
	u16 wNextFreeID;//
	u16 wFixup[0x10];//
} mft_head;

typedef struct tag_RESIDATTR {
	u32 ulDataSize;
	u16	usRDataOffset;
	short wUnknownAttrIndexID; 
} RESIDATTR, *LPRESIDATTR;

typedef struct tag_NONRESIDATTR {
	uint64_t	ullVCNStart;
	uint64_t	ullVCNEnd;
	u16		usNrDataOffset;
	short		wComprEngine;
	int		deReserve2;
	uint64_t	ullAllocSize;
	uint64_t	ullDataSize;
	uint64_t	ullInitSize;
	uint64_t	ullComprSize; 
} NONRESIDATTR, *LPNONRESIDATTR;

typedef struct tag_MFTATTR {
	int	dwAttrType;//attr type
	u16	usAttrSize;//���Դ�С����������ͷ��
	short	wReserve1;
	byte	bISResident;
	byte	bLenName;//����������
	u16	usDataOffset; 	// ������ƫ��
	short	wISCompr;//
	short	wAttrID;//����ID
	union unAttrib{
		RESIDATTR	ResidAttr;
		NONRESIDATTR	NonResidAttr;
	} unAttrib;
} MFTATTR, *LPMFTATTR;



typedef struct tag_FILE_NAME
{
	u32		dwMFTIndex;
	short		wReserve1;
	short		wReserve2;
	uint64_t	ullTime1;
	uint64_t	ullTime2;
	uint64_t	ullTime3;
	uint64_t	ullTime4;
	uint64_t	ullAllocSize;
	uint64_t	ullFileSize;
	uint64_t	ullFileAttr;
	byte		bNameLen;
	byte		bNameType;
	WCHAR		pwChar[MAX_PATH];
} FILE_NAME, *LPFILENAME;

typedef struct tag_INDXENTRY
{
	u32		dwMFTIndx;
	u32		dwReserve1;
	short		wEntrySize;
	short		wReserve2;
	byte		bISSubNode;
	byte		bReserve3[3];
	u32		dwAppear;
	u32		dwReserve4;
	uint64_t	ullFileTime[4];
	uint64_t	ullDataAlcSize;
	uint64_t	ullDataSize;
	uint64_t	ullReserve5;
	byte		bNameLen;
	byte		bNameType;
	WCHAR		wzFileName[MAX_PATH];

} INDXENTRY, *LPINDXENTRY;

typedef struct tag_INDX
{
	byte		bDirID[4];
	short		wFixupOffset;
	short		wFixupNum;
	byte		wReserve1[8];
	byte		bReserve2[8];
	short		wHeadSize;
	short		wReserve3;
	u32		dwUseSize;
	u32		dwAllocSize;
	u32		dwReserve3;
	byte		bFixup[0x0A];

} INDX, *LPINDX;

typedef struct tag_INDXATTR
{
	u32		dwMFTIndx;
	short		wReserve1;
	short		wReserve2;
	short		wcbSize;
	short		wNameAttrLen;
	short		wISSubNode;
	byte		bReserve3[2];
	u32		dwParentMFTIndx;
	u32		dwReserve4;
	uint64_t	ullCreateTime;
	uint64_t	ullLastModTime;
	uint64_t	ullModRcdTime;
	uint64_t	ullLastAccTime;
	uint64_t	ullAllocSize;
	uint64_t	ullFileSize;
	uint64_t	ullFileFlags;
	byte		bFileNameLen;
	byte		bFileNSpace;
	WCHAR		wzFileName[MAX_PATH];

} INDXATTR, *LPINDXATTR;

typedef struct tag_INDXROOT
{
	u32		dwAttrType;
	u32		dwConRule;
	u32		dwEntrySize;
	byte		bClusterPerIndex;
	byte		bPad[3];

} INDXROOT, *LPINDXROOT;

typedef struct tag_INDXHEAD{
	u32		dw1IndxOffset;//��һ���������ƫ��
	u32		dwIndxSize;//��������ܴ�С
	u32		dwInxAlcSize;//������ķ���
	byte		bFlags;
	byte		bPad[3];
} INDXHEAD, *LPINDXHEAD;

#pragma pack()

/*basic const definition*/
typedef enum
{
  AttributeStandardInformation = 0x10,
  AttributeAttributeList = 0x20,
  AttributeFileName = 0x30,
  AttributeObjectId = 0x40,
  AttributeSecurityDescriptor = 0x50,
  AttributeVolumeName = 0x60,
  AttributeVolumeInformation = 0x70,
  AttributeData = 0x80,
  AttributeIndexRoot = 0x90,
  AttributeIndexAllocation = 0xA0,
  AttributeBitmap = 0xB0,
  AttributeReparsePoint = 0xC0,
  AttributeEAInformation = 0xD0,
  AttributeEA = 0xE0,
  AttributePropertySet = 0xF0,
  AttributeLoggedUtilityStream = 0x100
} ATTRIBUTE_TYPE, *PATTRIBUTE_TYPE;

void test_read_ntfs_header(void);

#endif
