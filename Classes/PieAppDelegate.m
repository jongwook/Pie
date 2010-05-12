//
//  PieAppDelegate.m
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PieAppDelegate.h"
#import "PieViewController.h"

@implementation PieAppDelegate

@synthesize window;
@synthesize viewController;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	pie=[[PieConnection alloc] init];
	[pie connectToHost:@"cagsky.kaist.ac.kr"];
	viewController.pie=pie;
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[pie release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
