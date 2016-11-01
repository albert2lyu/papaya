#ifndef FCNTL_H
#define FCNTL_H

#define O_CREAT		 01000	/* not fcntl */
#define O_TRUNC		 02000	/* not fcntl */
#define O_EXCL		 04000	/* not fcntl */
#define O_NOCTTY	010000	/* not fcntl */

#define O_NONBLOCK	 00004
#define O_APPEND	 00010
#define O_SYNC		040000
#define O_DIRECTORY	0100000	/* must be a directory */
#define O_NOFOLLOW	0200000 /* don't follow links */
#define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
#define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
#define O_NOATIME	04000000
#define O_CLOEXEC	010000000 /* set close_on_exec */

#endif
