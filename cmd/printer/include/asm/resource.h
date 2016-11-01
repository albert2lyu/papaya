#ifndef RESOURCE_H
#define RESOURCE_H
enum{
	RLIMIT_CPU ,	/* CPU time in ms */
	RLIMIT_FSIZE ,	/* Maximun filesize */   
	RLIMIT_NOFILE ,	/*max number of open files */

	/* -------------above------------------*/
	RLIMIT_MAX
};

struct rlimit{
	unsigned cur;	/* soft limit */
	unsigned max;	/* hard limit */
};
#endif
