#include<valType.h>
#include<linux/printf.h>

static char *value2str(u32 value, char t_flag, char *ascii_buf,  int buflen );
static u32 taste_decimal(char *ptr, int *charnum);
static int write_chars(char *dest, char *src,  char *endflags, int width);
static int write_variable(char *buf, u32 value, char flag, int width);


int sprintf(char *buf, char *format, ...){
	return __sprintf(buf, format, (u32 *)(&format + 1));		
}

int __sprintf(char *buf, char *format, u32 *args){
	int width;
	int nr_wr;
	char *flag = format;
	char *dest = buf;
	u32 *arg = args;

	while(*flag){
		if(*flag == '%'){
			flag++;
			if(*flag == '*'){
				width = *(arg++);
				flag++;
			}
			else if(*flag <= '9' && *flag >= '1'){
				int charnum;
				width = taste_decimal(flag, &charnum);
				flag += charnum;
			}
			else width = 0;

			nr_wr = write_variable(dest, *arg++, *flag, width);
			flag++;
		}
		/* common character */
		else{
			/* 这儿小心。 返回的的写入的byte数量，如果有width，这个返回值不能
			 * 用于read指针的调整。 所幸这儿的width一定是0, so, nr_wr = nr_rd*/
			nr_wr = write_chars(dest, flag, "%", 0);
			flag += nr_wr;
		}
		dest += nr_wr;
	}
	dest[0] = 0;
	return dest - buf;
}

static u32 taste_decimal(char *ptr, int *charnum){
	char *start = ptr;
	int n = 0;
	u32 sum = 0;

	while(*ptr >= '0' && *ptr <= '9') ptr++;
	n = ptr - start;
	for(int i = 1; i <= n; i++){
		int s = ptr[-i] - '0';
		sum += s * pow_int(10, i-1);
	}
	*charnum = n;
	return sum;
}

/*TODO may be better just returning a boolean value */
static inline char *strchar(char *str, char c){
	if(!str) return 0;
	char *curr = str;
	while(*curr){
		if(*curr == c) return curr;
		curr++;
	}
	return 0;
}

/* @return how many bytes were written ?
 * @endflags
 * @wdith	0: ignore;	
 			>strlen:	padding in right side
			<strlen: 	trunk
 */
static int write_chars(char *dest, char *src,  char *endflags, int width){
	char *write = dest;
	char *read = src;

	while(*read && strchar(endflags, *read) == 0){

		*write++ = *read++;
		if(write - dest == width) break;
	}
	if(width){
		while(write - dest < width){
			*write++ = ' ';	
		}
	}

	return write - dest;
}

/* @value 	tell me the value of this variable
 * @flag 	tell me the type of this variable
 * @width   tell me the width limit when convert this variable to string
 * @buf     I will write it to @buf as a string.
 * 
 * @e.g.    write_variable(0xb8000, 0x123, 'u', 0);			==> 123
 *          write_variable(0xb8000, 0x123, 'x', 0);			==> 0x123
 * 			write_variable(str, "hellohello", 's', 5);		==> hello
 * Note!    None 'EOF' character appended.
 */
static int write_variable(char *buf, u32 value, char flag, int width){
	#define VALUE_LEN 31
	char valuestr[VALUE_LEN + 1];
	int nr_wr;					/*how many bytes we write */
	char *result;
	switch(flag){
		case 's':
			nr_wr = write_chars(buf, (char *)value, "%", width);
			break;
		case 'u':
		case 'x':
		case 'c':
			result = value2str(value, flag, valuestr, VALUE_LEN+1);
			nr_wr = write_chars(buf, result, 0, width);
			break;
		default:
			while(1);
						
	}
	return nr_wr;
}


/* @t_flag How should we interpret this variable, integer(d), unsigned(u) or 
 *		   hexadecimal(x) ?
 */
static char *value2str(u32 value, char t_flag, char *ascii_buf,  int buflen ){
	unsigned temp = value;
	int offset = buflen - 1 - 1;		/* reserve the tail byte as EOF */

	ascii_buf[buflen - 1] = 0;
	switch(t_flag){
		case 'c':
			ascii_buf[offset] = value;
			break;

		/*	Decomposition unsigned integer */
		case 'u':
			while(temp>9){
				ascii_buf[offset]=temp%10+48;
				temp/=10;
				offset--;
			}
			ascii_buf[offset]=temp+48;
			break;
		case 'x':
			while(temp>0xf){
				unsigned i=temp%16;
				ascii_buf[offset]=i<=9?i+48:i+87;
				temp/=16;
				offset--;
			}
			/*Write 0X prefix */
			ascii_buf[offset--] = temp<=9?temp+48:temp+87;
			ascii_buf[offset--] = 'X';
			ascii_buf[offset] = '0';
			break;
		default:
			while(1);
	}
	return ascii_buf + offset;
}










