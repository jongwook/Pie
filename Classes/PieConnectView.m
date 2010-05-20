//
//  PieConnectView.m
//  Pie
//
//  Created by Jong Wook Kim on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PieConnectView.h"


@implementation PieConnectView

@synthesize address, port, appDelegate;

-(IBAction)connect {
	if(address.text.length==0) {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Invalid Address" message:@"Please enter the server address" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	} else if(port.text.intValue==0) {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Invalid Port Number" message:@"Please enter a valid port number" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	[defaults setObject:address.text forKey:@"host"];
	[defaults setObject:port.text forKey:@"port"];
	[appDelegate connectToHost:address.text onPort:port.text.intValue];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self connect];
	return YES;
}

-(IBAction)blur {
	[address resignFirstResponder];
	[port resignFirstResponder];
}

@end
