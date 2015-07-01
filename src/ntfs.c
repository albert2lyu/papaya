#include <disp.h>
#include <ntfs.h>
#include <fs.h>
#include <hs.h>
#include <fs_ext.h>
#include <proc.h>
#include <sys_call.h>
#include <disp.h>
#include <struinfo.h>
#include <utils.h>
#include <ku_utils.h>

#define CONST_BLOCK_SIZE 512
/*ntfs_header header_info;*/

int lba_base_ntfs = 0;

void print_ntfs_header(ntfs_header *header)
{
    assert(header!=0);

    oprintf("bNTFlags = %c,%c,%c,%c\n",
	    header->bNTFlags[0],
	    header->bNTFlags[1],
	    header->bNTFlags[2],
	    header->bNTFlags[3]);

test:
    oprintf("test var = 0,%c",(char)0);

    oprintf("bytes per sector:%x,sectors per Cluster %x, %x sectors reserved\n",
	    (unsigned int)header->wBytePerSector,
	    (unsigned int)header->bSectorPerCluster,
	    (unsigned int)header->wReserveSectors);
}

#define ROOT_DIR_OFFSET 0x1400
/*
$MFT---header
$MFTMirr
$LogFile
$Volume
$AttrDef
. (分区根目录)
$Bitmap
$Boot
$BadClus
$Secure
$UpCase
$Extend
*/
void printf_mtf_header(mft_head * header)
{
	oprintf("MFT Head ID: %c, %c ,%c, %c\n",
			header->bHeadID[0],
			header->bHeadID[1],
			header->bHeadID[2],
			header->bHeadID[3]);
	oprintf("MFT head first attr offset:%u\n",(int)(header->usAttrOffset));
	oprintf("MFT head size %u,allocated size %u\n",header->ulMFTSize,
			header->ulMFTAllocSize);
}


void attr_name(ATTRIBUTE_TYPE e_attr_type)
{
	char * pc_name;
	switch(e_attr_type)
	{
		case AttributeStandardInformation:
			pc_name = "AttributeStandardInformation";
			break;
		case AttributeLoggedUtilityStream:
			pc_name = "AttributeLoggedUtilityStream";
			break;
		case AttributeBitmap:
			pc_name = "AttributeBitmap";
			break;
		case AttributeData:
			pc_name = "AttributeData";
			break;
		case AttributeEA:
			pc_name = "AttributeEA";
			break;
		case AttributeEAInformation:
			pc_name = "AttributeEAInformation";
			break;
		case AttributeFileName:
			pc_name = "AttributeFileName";
			break;
		case AttributeIndexAllocation:
			pc_name = "AttributeIndexAllocation";
			break;
		case AttributeIndexRoot:
			pc_name = "AttributeIndexRoot";
			break;
		case AttributeObjectId:
			pc_name = "AttributeObjectId";
			break;
		case AttributePropertySet:
			pc_name = "AttributePropertySet";
			break;
		case AttributeReparsePoint:
			pc_name = "AttributeReparsePoint";
			break;
		case AttributeSecurityDescriptor:
			pc_name = "AttributeSecurityDescriptor";
			break;
		case AttributeVolumeInformation:
			pc_name = "AttributeVolumeInformation";
			break;
		case AttributeVolumeName:
			pc_name = "AttributeVolumeName";
			break;
		case AttributeAttributeList:
			pc_name = "AttributeAttributeList";
			break;
		default:
			pc_name = "UNKNOWN ATTRIBUTE";
			break;
	}
	oprintf("Attrbute:%s",pc_name);
}

void dummy_print_idx_head(INDXHEAD*idx_head)
{
	oprintf("basic: first idx offset %u,total_size %u,allocated_size %u\n",
			idx_head->dw1IndxOffset,
			idx_head->dwIndxSize,
			idx_head->dwInxAlcSize);
}

void dummy_print_idxentry(INDXENTRY* entry)
{
	oprintf("file name is %s unicode,length = %u,size %u\n",
			(entry->bNameType&0x01)?"":"Not",
			(u32)entry->bNameLen,
			(u32)entry->wEntrySize);
	if(entry->bNameLen == 0)
		return;

	oprintf("File Name:");
	for(int i =0 ;i < entry->bNameLen ; i++)
		oprintf("%c",(char)(0x00FF&entry->wzFileName[i]));
	oprintf("\n");
}

void Analyze_IDX_Root(void *addr)
{
	INDXROOT* idx_root = (INDXROOT*)addr;
	oprintf("Index Root:");
	attr_name(idx_root->dwAttrType);
	oprintf("\ndwEntrySize = %u,bClusterPerIndex=%u\n",
			(u32)idx_root->dwEntrySize,
			(u32)idx_root->bClusterPerIndex);
	INDXHEAD *idx_head = (char*)idx_root +sizeof(INDXROOT);
	dummy_print_idx_head(idx_head);

	INDXENTRY *entry = (char*)idx_head + idx_head->dw1IndxOffset;

	while(entry->dwMFTIndx != 0 && entry->dwMFTIndx != -1L)
	{
		if(entry->bNameType & 0x01L == 0)
		{
			entry = (char*)entry + entry->wEntrySize;
			continue;
		}
	}

	dummy_print_idxentry(entry);
}
void Print_AttrFileName(FILE_NAME *attr_filename)
{
	oprintf("Filename Length = %u,Unicode %u\n",
			(u32)attr_filename->bNameLen,
			(u32)attr_filename->bNameType
			);
	if(attr_filename->bNameLen == 0)
		return;
	oprintf("FileName:");
	for(int i = 0; i < attr_filename->bNameLen;i++)
	{

		oprintf("%x",attr_filename->pwChar[i]);
		oprintf("  ");
	}
	oprintf("\n");
}
void print_mftattr_name(MFTATTR *attr)
{
	if(attr->bLenName == 0)
	{
		oprintf("no name\n");
	}
	else
	{
		oprintf("attr name %u bytes:",attr->bLenName);
		char *name = (char*)attr + attr->usDataOffset;
		for(int i =0 ; i < attr->bLenName *2 ; i++)
		{
			oprintf("%c",*(name+i));
		}
		oprintf("\n");
	}
}

void Analyze_MFT_Root(mft_head *root)
{
	u16 att_offset = root->usAttrOffset;
	MFTATTR *mft_attr = (byte*)root + att_offset;
	
	while(att_offset < root->ulMFTSize && mft_attr->dwAttrType != -1L)
	{
#if 1
		attr_name((ATTRIBUTE_TYPE)mft_attr->dwAttrType);
		oprintf(",attribute size %u bytes,isRes:%u\n",
				(u32)mft_attr->usAttrSize,
				(u32)mft_attr->bISResident
				);
#endif
		print_mftattr_name(mft_attr);

#if 1
		if(mft_attr->dwAttrType == AttributeIndexRoot && mft_attr->bISResident == 0)
		{
			oprintf("ResidAttr.usRDataOffset=%u\n",
					(u32)mft_attr->unAttrib.ResidAttr.usRDataOffset);
			Analyze_IDX_Root((char*)mft_attr+
					sizeof(MFTATTR));
		}
#endif
		mft_attr = (MFTATTR*)((byte*)mft_attr + mft_attr->usAttrSize);

	}
}

void test_read_ntfs_header(void){
	int i = 0, j = 0;

	for(i=0; i< MAX_DEVICE; i++){
		for(j=0; j < MAX_PARTATION; j++){
			if(g_dp[i][j].sys_id == SYSID_NTFS) break;
		}
		if(j != MAX_PARTATION) break;
	}
	
	if(j == MAX_PARTATION){
		oprintf("failed to find any NTFS partition!!\n");
		return ;
	}
	else{ 
		oprintf("found NTFS partition on device No.%u,partition No.%u\n",i,j);
	}

	ntfs_header * header = kmalloc(CONST_BLOCK_SIZE);
	askhs(COMMAND_READ,(int)g_dp[i][j].start_lba,1,(char*)header);
	lba_base_ntfs = g_dp[i][j].start_lba;
	print_ntfs_header(header);
	kfree(header);
	
	uint64_t start_mft_clusters = header->ullMFTAddr;
	unsigned int high_4_bytes = (start_mft_clusters>>32) &0xFFFFFFFF;
	unsigned int low_4_bytes = (start_mft_clusters)&0xFFFFFFFF;
	unsigned int sectors_per_clusters = header->bSectorPerCluster;
	unsigned int bytes_per_sectors = header->wBytePerSector;
	
	oprintf("MFT Clusters high 4 bytes: %x, low 4 bytes %x\n",high_4_bytes,low_4_bytes);
	if((high_4_bytes != 0) ||
		    (ffs32(low_4_bytes)+ffs32(sectors_per_clusters))>28)/*since askfs only support a 28-bit lba arguement */
	{
		oprintf("sigh..papaya cannot handle file system \n");
		return;
	}
	
	unsigned int mft_lba = sectors_per_clusters * low_4_bytes + lba_base_ntfs; 
	mft_head * mft_header_data = kmalloc(bytes_per_sectors);
	askhs(COMMAND_READ,mft_lba,1,(char*)mft_header_data);
	printf_mtf_header(mft_header_data);

#define ROOT_MFT_SEQ 6


#if 1
	for(int i = 1; i < ROOT_MFT_SEQ ; i++)
	{
		mft_lba += mft_header_data->ulMFTAllocSize/ bytes_per_sectors;
		kfree(mft_header_data);
		mft_header_data = kmalloc(bytes_per_sectors);
		askhs(COMMAND_READ,mft_lba,1,(char*)mft_header_data);

		oprintf("position mft_lba:%u\n",mft_lba);
		printf_mtf_header(mft_header_data);

	}
#endif

	if(mft_header_data->ulMFTSize > bytes_per_sectors)
	{
		u32 length_bytes = mft_header_data->ulMFTSize;
		kfree(mft_header_data);
		u8 sectors_mft = length_bytes / bytes_per_sectors + (length_bytes % bytes_per_sectors)==0?0:1;
		askhs(COMMAND_READ,mft_lba,sectors_mft,(char*)mft_header_data);
	}

	/*now we get $MFT_ROOT*/
	Analyze_MFT_Root(mft_header_data);

	kfree(mft_header_data);
}


