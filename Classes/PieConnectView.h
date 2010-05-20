//
//  PieConnectView.h
//  Pie
//
//  Created by Jong Wook Kim on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieAppDelegate.h"

@interface PieConnectView : UIView<UITextFieldDelegate> {
	PieAppDelegate *appDelegate;
	UITextField *address;
	UITextField *port;
}

-(IBAction) connect;

@property (nonatomic,retain) PieAppDelegate *appDelegate;
@property (nonatomic,retain) IBOutlet UITextField *address;
@property (nonatomic,retain) IBOutlet UITextField *port;

@end
