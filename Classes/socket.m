#include "socket.h"

#ifdef TARGET_WINDOWS
static bool bInit=false;
static void socket_init() {
	WSADATA wsaData;
	if(WSAStartup(MAKEWORD(2,2),&wsaData)!=0) {
		fprintf(stderr,"WSAStartup() failed");
	}	
}
#endif

SOCKET socket_create() {
#ifdef TARGET_WINDOWS
	if(!bInit) socket_init();
#endif
	SOCKET sock=socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(sock == -1) {
		fprintf(stderr,"socket() Failed\n");
		exit(-1);
	}
	return sock;
}

int socket_connect(SOCKET sock, const char * server, int port) {
	struct hostent *ent;
	struct sockaddr_in serv_addr;

	ent = gethostbyname(server);
	if(ent==NULL) return -1;
	

	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_addr.s_addr=*(unsigned long *)(ent->h_addr_list[0]);
	serv_addr.sin_port=htons(port);
	
	if(connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr))==-1) {
		fprintf(stderr,"connect() Failed\n");
		exit(-1);
	}

	return 0;
}

int socket_send(SOCKET sock, const char * message, int length) {
	int sent=0, ret;
	while(sent<length) {
		ret=send(sock, message+sent, length-sent,0);
		if(ret==-1) {
			fprintf(stderr,"socket write() Failed\n");
			return -1;
		}
		sent+=ret;
	}
	return 0;
}

int socket_receive(SOCKET sock, char * message, int length) {
	if(!socket_poll(sock)) return 0;
	int ret=recv(sock, message, length, 0);
	if(ret==-1) 
		fprintf(stderr,"socket recv() Failed\n");
	return ret;
}

bool socket_poll(SOCKET sock) {
	fd_set readset;
	struct timeval timeout={1,0};

	FD_ZERO(&readset);
	FD_SET(sock,&readset);
	select(sock+1,&readset,NULL,NULL,&timeout);
	if(FD_ISSET(sock,&readset)) return true;
	return false;
}

int socket_close(SOCKET sock) {
#ifdef TARGET_WINDOWS
	closesocket(sock);
#else
	close(sock);
#endif
	return 0;
}
