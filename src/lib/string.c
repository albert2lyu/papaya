#include<linux/string.h>

//有更好的写法，但这样更易读
ulong strnlen(char *str, ulong n){
	for(int i = 0; i < n; i++){
		if(str[i] == 0) return i;
	}
	return n;
}

//TODO  ugly
int strlen(char*str){
	int len=0;
	while(*str!=0){
		str++;
		len++;	
	}
	return len;
}

bool strmatch(char*seg,char*whole){
	for(int i=0;i<strlen(seg);i++){
		if(seg[i]!=whole[i]) return false;
	}
	return true;
}

char*strcpy(char*dest,char*src){
	char*d=dest;
	while((*dest++=*src++));
	return d;
}
/*
  Warning:  
  1, If there is no null byte among the first n bytes of src, the
  string placed in dest will not be null-terminated.
  2, If the length of src is less than n, strncpy() writes additional null  bytes  to
  dest to ensure that a total of n bytes are written.
  */
char *strncpy(char *dest, const char *src, int n){
	int i;
	for(i = 0; i < n && src[i]; i++){
		dest[i] = src[i];	
	}
	for (; i<n; i++) dest[i] = 0;
	return dest;
}

/* the following two functions are not standardly implemented */
int strcmp(const char *str1, const char *str2){
	int i;
	for(i = 0; str1[i] == str2[i]; i++){
		if(str1[i] == 0) return 0;
	}
	return i + 1;

}

int strncmp(const char *str1, const char *str2, int n){
	for(int i = 0; i < n; i++){
		if(str1[i] == str2[i]) {
			if(str1[i]) continue;
			else return 0;
		}
		else return i + 1;
	}
	return 0;	
}
