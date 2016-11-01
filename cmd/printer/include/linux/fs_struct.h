#ifndef FS_STRUCT_H
#define FS_STRUCT_H
struct fs_struct{
	struct dentry *root, *pwd;
	struct vfsmount *rootmnt, *pwdmnt;
};
#endif
