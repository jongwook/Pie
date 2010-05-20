//
//  PieAppDelegate.h
//  Pie
//
//  Created by Jong Wook Kim on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieConnection.h"

@class PieViewController;
@class PieConnectView;

@interface PieAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PieViewController *viewController;
	PieConnection *pie;
	PieConnectView *pieConnectView;
}

-(void) connectToHost:(NSString *)host onPort:(int)port;
-(void) restart;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PieViewController *viewController;
@property (nonatomic, retain) IBOutlet PieConnectView *pieConnectView;

@end

