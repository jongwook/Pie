
#ifndef _SOCKET_H
#define _SOCKET_H




#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>


#if defined(__WIN32__) || defined(_WIN32)
	#define TARGET_WINDOWS

	#include <WinSock2.h>
	#pragma comment(lib, "ws2_32.lib") 

	#define socklen_t int
#else
	#define TARGET_UNIX
	
	#include <unistd.h>
	#include <arpa/inet.h>
	#include <sys/socket.h>
	#include <netdb.h>

	#define SOCKET int
#endif


#ifdef __cplusplus
extern "C" {
#endif

SOCKET socket_create();
int socket_connect(SOCKET sock, const char * server, int port);
int socket_send(SOCKET sock, const char * message, int length);
int socket_receive(SOCKET sock, char * message, int length);
bool socket_poll(SOCKET sock);
int socket_close(SOCKET sock);

#ifdef __cplusplus
}
#endif
	
#endif

