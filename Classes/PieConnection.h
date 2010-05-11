//
//  PieConnection.h
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

#define TERMINAL_ROWS 24
#define TERMINAL_COLS 80

@interface PieConnection : NSObject {
	AsyncSocket *socket;
	NSError *error;
	unichar screen[TERMINAL_ROWS][TERMINAL_COLS];
	int foreground[TERMINAL_ROWS][TERMINAL_COLS];
	int background[TERMINAL_ROWS][TERMINAL_COLS];
	int currentRow, currentCol;
	int savedRow, savedCol;
}

-(BOOL) connectToHost:(NSString *)host;
-(BOOL) connectToHost:(NSString *)host onPort:(int)port;

-(void) onSocketDidDisconnect:(AsyncSocket *)sock;
-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
-(void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;


@end
