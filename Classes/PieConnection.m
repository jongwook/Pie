//
//  PieConnection.m
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PieConnection.h"

@implementation PieConnection

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
}

-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	NSLog(@"Will Disconnect with error : %@",err);
}

-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	NSLog(@"Connected to the host!");
	NSData *data=[@"HEAD / HTTP/1.0\nHost:google.com\n\n" dataUsingEncoding:NSUTF8StringEncoding];
	[sock writeData:data withTimeout:-1 tag:1234L];
	[sock readDataWithTimeout:10 tag:4321L];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSLog(@"Hi");
	NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Read Data : %@",str);
	[str release];
}

-(void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"Data Written! %d",tag);
}


@end
