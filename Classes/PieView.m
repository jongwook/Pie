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

@synthesize pie, cursor;

-(void)didMoveToSuperview {
	
}

-(void)drawRect:(CGRect)rect {
	font=[UIFont fontWithName:@"Courier" size:16.0f];
	defaultForeground=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
	defaultBackground=[UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1.0].CGColor;
	cursorColor=[UIColor colorWithRed:0.4 green:1.0 blue:0.0 alpha:1.0].CGColor;
	
	colors[0]=[UIColor blackColor].CGColor;
	colors[1]=[UIColor redColor].CGColor;
	colors[2]=[UIColor greenColor].CGColor;
	colors[3]=[UIColor yellowColor].CGColor;
	colors[4]=[UIColor blueColor].CGColor;
	colors[5]=[UIColor magentaColor].CGColor;
	colors[6]=[UIColor cyanColor].CGColor;
	colors[7]=[UIColor whiteColor].CGColor;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// background rendering
	for (int i=0;i<TERMINAL_ROWS;i++) {
		for(int j=0;j<TERMINAL_COLS;j++) {
			int index=i*TERMINAL_COLS+j;
			int colorindex=pie.background[index];
			CGColorRef color=(colorindex==-2)?defaultBackground:(colorindex==-1)?defaultForeground:colors[colorindex];
			CGContextSetFillColorWithColor(context, color);
			CGRect tmprect=CGRectMake(j*8.f, i*20.0f, 8.0f, 20.0f);
			CGContextAddRect(context,tmprect);
			CGContextFillRect(context,tmprect);			
		}
	}
	
	// draw cursor
	CGContextSetFillColorWithColor(context, cursorColor);
	CGRect tmprect=CGRectMake(pie.currentCol*8.f, pie.currentRow*20.0f, 8.0f, 20.0f);
	CGContextAddRect(context,tmprect);
	CGContextFillRect(context,tmprect);	
	
	// text rendering
	for (int i=0;i<TERMINAL_ROWS;i++) {
		for(int j=0;j<TERMINAL_COLS;j++) {
			int index=i*TERMINAL_COLS+j;
			int colorindex=pie.foreground[index];
			CGColorRef color=(colorindex==-2)?defaultBackground:(colorindex==-1)?defaultForeground:colors[colorindex];
			CGContextSetFillColorWithColor(context, color);			
			NSString *str=[NSString stringWithFormat:@"%C", pie.screen[index]];
			[str drawAtPoint:CGPointMake(j*8.0f,i*20.0f) withFont:font];
		}
	}
	
	
}

@end
