//
//  PieConnection.h
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

@interface PieConnection : NSObject {
	AsyncSocket *socket;
	NSError *error;
}

-(BOOL) connectToHost:(NSString *)host;
-(BOOL) connectToHost:(NSString *)host onPort:(int)port;

-(void) onSocketDidDisconnect:(AsyncSocket *)sock;
-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
-(void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;


@end
