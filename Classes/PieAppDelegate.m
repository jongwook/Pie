//
//  PieAppDelegate.m
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PieAppDelegate.h"
#import "PieViewController.h"
#import "PieConnectView.h"

@implementation PieAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize pieConnectView;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	NSArray *nibViews=[[NSBundle mainBundle] loadNibNamed:@"PieConnectView" owner:self options:nil];
	pieConnectView=[nibViews objectAtIndex:0];
	pieConnectView.appDelegate=self;
	[window addSubview:pieConnectView];
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	if([defaults stringForKey:@"host"]!=nil) 
		pieConnectView.address.text=[defaults stringForKey:@"host"];
	if([defaults stringForKey:@"port"]!=nil)
		pieConnectView.port.text=[defaults stringForKey:@"port"];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[pie release];
    [viewController release];
    [window release];
    [super dealloc];
}


-(void) connectToHost:(NSString *)host onPort:(int)port {
	if(pie==nil)
		pie=[[PieConnection alloc] init];
	[pie connectToHost:host onPort:port];
	viewController.pie=pie;
	viewController.appDelegate=self;
	pie.viewController=viewController;
	[viewController.textField becomeFirstResponder];
	
	[window sendSubviewToBack:pieConnectView];
	[window addSubview:viewController.view];
}

-(void) restart {
	[pie init];
	[window sendSubviewToBack:viewController.view];
}

@end
