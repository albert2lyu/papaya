#ifndef ASSERT_H
#define ASSERT_H

void assert_func(char*exp,char*file,char*base_file,int line);

#define assert(exp)														\
	do{ 																\
		if(!(exp)) assert_func(#exp,__FILE__,__BASE_FILE__,__LINE__);	\
	  } while(0)


#define asrt assert
#endif
