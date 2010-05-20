//
//  PieView.h
//  Pie
//
//  Created by Jong Wook Kim on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieAppDelegate.h"

@class PieConnection;

@interface PieView : UIView {
	
	PieConnection *pie;
	UIFont *font;
	CGColorRef defaultForeground, defaultBackground, cursorColor;
	CGColorRef colors[8];
	UILabel *cursor;
}

@property (nonatomic,retain) PieConnection *pie;
@property (nonatomic,retain) IBOutlet UILabel *cursor;

@end
