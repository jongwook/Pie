//
//  PieView.h
//  Pie
//
//  Created by Jong Wook Kim on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieConnection;

@interface PieView : UIView {
	PieConnection *pie;
	UIFont *font;
	CGColorRef defaultForeground, defaultBackground;
	CGColorRef colors[8];
}

@property (nonatomic,retain) PieConnection *pie;

@end
