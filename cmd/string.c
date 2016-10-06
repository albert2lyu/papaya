#include"string.h"
int strlen(char*str){
	int len=0;
	while(*str!=0){
		str++;
		len++;	
	}
	return len;
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
