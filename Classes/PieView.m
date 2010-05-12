//
//  PieView.m
//  Pie
//
//  Created by Jong Wook Kim on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PieView.h"
#import "PieConnection.h"

@implementation PieView

@synthesize pie;

-(void)didMoveToSuperview {
	// initialization
	font=[UIFont fontWithName:@"Courier" size:16.0f];
	NSLog(@"PieView Initialized");
	
}

-(void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	
	for (int i=0;i<TERMINAL_ROWS;i++) {
		for(int j=0;j<TERMINAL_COLS;j++) {
			NSString *str=[NSString stringWithFormat:@"%C", pie.screen[i*TERMINAL_COLS+j]];
			[str drawAtPoint:CGPointMake(j*8.0f,i*20.0f) withFont:font];
		}
	}
}
@end
