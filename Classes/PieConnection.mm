//
//  PieConnection.m
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#include <sstream>

#import "PieConnection.h"

#define BETWEEN(x,a,b) ( (x)>=(a) && (x)<=(b) )

static std::stringstream buffer;
static int bufferlen=0;

@implementation PieConnection

-(id) init {
	currentRow=currentCol=0;
	savedRow=savedCol=0;
	currentForeground=currentBackground=-1;
	encoding=-2147482590;	// cp949
	for(int i=0;i<TERMINAL_ROWS;i++) {
		for(int j=0;j<TERMINAL_COLS;j++) {
			screen[i][j]=' ';
			foreground[i][j]=-1;
			background[i][j]=-1;
		}
	}
	return self;
}

-(BOOL) connectToHost:(NSString *)host {
	return [self connectToHost:host onPort:23];
}

-(BOOL) connectToHost:(NSString *)host onPort:(int)port {
	socket=[[AsyncSocket alloc]initWithDelegate:self userData:0L];
	[socket connectToHost:host onPort:port error:&error];
	
	return YES;
}

-(void) dealloc {
	[socket release];
	[super dealloc];
}

-(void) onSocketDidDisconnect:(AsyncSocket *)sock {
	NSLog(@"Socket Disconnected");
}

-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	NSLog(@"Will Disconnect with error : %@",err);
}

-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	NSLog(@"Connected to the host!");
	[self send:"\xff\xfb\x1f"];
	[self send:"\xff\xfb\x20"];
	[self send:"\xff\xfb\x18"];
	[self send:"\xff\xfb\x27"];
	[self send:"\xff\xfd\x01"];
	[self send:"\xff\xfb\x03"];
	[self send:"\xff\xfd\x03"];
	[sock readDataWithTimeout:-1 tag:4321L];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	static char buf[512];
	NSLog(@"Received Data length : %d",data.length);
	for(int i=0;i<=(data.length-1)/512;i++) {
		int len=MIN((i+1)*512,data.length) - i*512;
		[data getBytes:buf range:NSMakeRange(i*512,i*512+len)];
		buffer.write(buf,len);
		bufferlen+=len;
	}
	for(int i=0;i<bufferlen;i++) {
		int c=buffer.get();
		printf("%02x ",c);
		buffer.write((char*)&c,1);
	}
	printf("\n");

	[self parse];
	[sock readDataWithTimeout:-1 tag:4321L];
}

-(void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	
}

-(void) parse {
	static char token[32]="";
	static int pos=0;
	int cursor=0;

	while(bufferlen>0) {
		if(pos==cursor) {
			token[pos++]=[self getchar];
		}
		cursor++;
		if(token[0]=='\xff') {	// negotiation
			if(pos==cursor) {
				if(bufferlen==0) return;	// required data is not availbe; stop parsing
				token[pos++]=[self getchar];
			}
			cursor++;
			char temp=0;
			switch(token[1]) {	// negotiation 
			case '\xf0':	// suboption end; should not get here
				break;
			case '\xfa':	// suboption start
				while(temp!='\xff') {
					if(pos==cursor) {
						if(bufferlen==0) return;	// stop parsing
						token[pos++]=[self getchar];
					}
					cursor++;
					temp=token[cursor];
				}
				if(pos==cursor) {
					if(bufferlen==0) return;	// stop parsing
					token[pos++]=[self getchar];
				}
				break;
			default:
				if(pos==cursor) {
					if(bufferlen==0) return;
					token[pos++]=[self getchar];
				}
			}
			token[pos]='\0';
			cursor=pos=0;
			[self negotiate:token];
		} else if(token[0]<0) {	// handle cp949 characters
			if(pos==cursor) {
				if(bufferlen==0) return;
				token[pos++]=[self getchar];
			}
			token[pos]='\0';
			cursor=pos=0;
			NSString *str=[NSString stringWithCString:token encoding:encoding];
			unichar c=[str characterAtIndex:0];
			[self drawChar:c];
		} else if (token[0]==0x1b) { // escape character
			if(pos==cursor) {
				if(bufferlen==0) return;
				token[pos++]=[self getchar];
			}
			cursor++;
			if (token[1]!='[') {
				token[0]=token[1];
				cursor=0;
				pos=1;
				continue;
			}
			int value[]={0,0,0}, cnt=0;
			while(true) {
				BOOL done=NO;
				if(pos==cursor) {
					if(bufferlen==0) return;
					token[pos++]=[self getchar];
				}
				cursor++;
				switch(token[pos-1]) {
					case '0': case '1': case '2': case '3': case '4':
					case '5': case '6': case '7': case '8': case '9':
						value[cnt]*=10;
						value[cnt]+=token[pos-1]-'0';
						break;
					case ';':
						cnt++;
						break;
					case 'H': case 'h':	// cursor position
						cnt++;
						currentRow=(cnt>=1)?value[0]:0;
						currentCol=(cnt>=2)?value[1]:0;
						done=YES;
						break;
					case 'J': case 'j':	// erase screen
						for(int i=0;i<TERMINAL_ROWS;i++) {
							for(int j=0;j<TERMINAL_COLS;j++) { 
								screen[i][j]=' ';
								foreground[i][j]=-1;
								background[i][j]=-1;
							}
						}
						done=YES;
						break;
					case 'M': case 'm': // set graphics mode
						cnt++;
						for(int i=0;i<cnt;i++) {
							if(value[i]==0) {
								currentForeground=-1;
								currentBackground=-1;
							} else if(value[i]>=30 && value[i]<40) {
								currentForeground=value[i]-30;
							} else if(value[i]>=40 && value[i]<50) {
								currentBackground=value[i]-40;
							}
						}
						done=YES;
						break;
					case 'U': case 'u':	// restore cursor position
						currentCol=savedCol;
						currentRow=savedRow;
						done=YES;
						break;
					case 'S': case 's':	// save cursor position
						savedRow=currentRow;
						savedCol=currentCol;
						done=YES;
						break;
				}
				if(done) {
					cursor=pos=0;
					break;
				}
			}
		} else if (token[0]=='\n') {
			[self newline];
			printf("\n");
			cursor=pos=0;
		} else if (token[0]=='\r' || token[0]=='\0') {
			cursor=pos=0;
		} else {
			printf("%c",token[0]);
			cursor=pos=0;
		}
	} 
}

-(char) getchar {
	bufferlen--;
	return buffer.get();
}

-(void) negotiate:(const char *)token {
	NSLog(@"Negotiating %02x %02x %02x",(UInt8)token[0],(UInt8)token[1],(UInt8)token[2]);
	switch(token[1]) {
		case '\xfa':
			// suboption begin
			switch(token[2]) {
				case '\x18':	// term type
					[self send:"\xff\xfa\x18"];
					[self send:"\x00" length:1];
					[self send:"XTERM"];
					[self send:"\xff\xf0"];
					break;
				case '\x20':	// term speed
					[self send:"\xff\xfa\x20"];
					[self send:"\x00" length:1];
					[self send:"38400,38400"];
					[self send:"\xff\xf0"];
					break;
				case '\x27':	// do new env opt
					[self send:"\xff\xfa\x27"];
					[self send:"\x00" length:1];
					[self send:"\xff\xf0"];
					break;
				default:
					[self send:token length:3];
					[self send:"\x00" length:1];
					[self send:"\xff\xf0"];
			}
			break;
		case '\xfb':
			// will
			break;
		case '\xfc':
			// won't
			break;
		case '\xfd':
			// do
			switch(token[2]) {
				case '\x18':	// PieTerminal type
					[self send:"\xff\xfd\x18"];
					break;
				case '\x1f':	// nego win size
					[self send:"\xff\xfa\x1f"];
					[self send:"\x00\x50\x00\x18" length:4];
					[self send:"\xff\xf0"];
					break;
				case '\x20':	// term speed
					[self send:"\xff\xfb\x20"];
					break;
				case '\x23':	// x disp loc
					[self send:"\xff\xfc\x23"];
					break;
				case '\x24':	// env opt
					[self send:"\xff\xfc\x24"];
					break;
				case '\x27':	// new env opt
					[self send:"\xff\xfc\x27"];
					break;
				default:
					[self send:"\xff\xfc"];
					[self send:&token[2] length:1];
			}
			break;
		case '\xfe':
			// don't
			switch(token[2]) {
				case '\x23':	// x disp loc
					[self send:"\xff\xfc\x23"];
					break;
				default:
					[self send:"\xff\xfc"];
					[self send:&token[2] length:1];
			}
			break;
	}	
}

-(void) send:(const char *)token {
	[self send:token length:strlen(token)];
}

-(void) send:(const char *)token length:(int)length {
	NSLog(@"Sending token length %d",length);
	for(int i=0;i<length;i++) {
		printf("%02x ",(UInt8)token[i]);
	}
	printf("\n");
	NSData *data=[NSData dataWithBytes:token length:length];
	[socket writeData:data withTimeout:-1 tag:1234L];
}

-(void) drawChar:(unichar)c {
	unichar prev=screen[currentRow][currentCol];
	if(currentCol>0) {
		unichar left=screen[currentRow][currentCol-1];
		if(left>0x80) {
			screen[currentRow][currentCol-1]='?';
		}
	}
	foreground[currentRow][currentCol]=currentForeground;
	background[currentRow][currentCol]=currentBackground;
	if(prev<0x80) {
		if(c<0x80) {
			screen[currentRow][currentCol]=c;
			currentCol++;
		} else {
			if(currentCol==TERMINAL_COLS-1) {
				screen[currentRow][currentCol]='?';
			} else {
				screen[currentRow][currentCol]=c;
				screen[currentRow][currentCol+1]=' ';
				foreground[currentRow][currentCol+1]=currentForeground;
				background[currentRow][currentCol+1]=currentBackground;
			}
			currentCol+=2;
		}
	} else {
		screen[currentRow][currentCol]=c;
		foreground[currentRow][currentCol+1]=currentForeground;
		background[currentRow][currentCol+1]=currentBackground;
		currentCol+=2;
	}
}

-(void) newline {
	currentCol=0;
	if(currentRow<23) {
		currentRow++;
	} else {
		for(int i=0;i<TERMINAL_ROWS;i++) {
			for(int j=0;j<TERMINAL_COLS;j++) {
				if(i<23) {
					screen[i][j]=screen[i+1][j];
					foreground[i][j]=foreground[i+1][j];
					background[i][j]=background[i+1][j];
				} else {
					screen[i][j]=' ';
					foreground[i][j]=-1;
					background[i][j]=-1;
				}
			}
		}
	}
}

@end
