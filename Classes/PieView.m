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
	font=[UIFont fontWithName:@"Courier" size:16.0f];
}

-(void)drawRect:(CGRect)rect {
	defaultForeground=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0].CGColor;
	defaultBackground=[UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1.0].CGColor;
	colors[0]=[UIColor blackColor].CGColor;
	colors[1]=[UIColor redColor].CGColor;
	colors[2]=[UIColor greenColor].CGColor;
	colors[3]=[UIColor yellowColor].CGColor;
	colors[4]=[UIColor blueColor].CGColor;
	colors[5]=[UIColor magentaColor].CGColor;
	colors[6]=[UIColor cyanColor].CGColor;
	colors[7]=[UIColor whiteColor].CGColor;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	BOOL skipBackground=NO;
	for (int i=0;i<TERMINAL_ROWS;i++) {
		for(int j=0;j<TERMINAL_COLS;j++) {
			int index=i*TERMINAL_COLS+j;
			//CGColorRef background=(pie.background[index]==-1)?defaultBackground:colors[pie.background[index]];
			if(skipBackground==NO) {
				CGContextSetFillColorWithColor(context, defaultBackground);
				CGRect rect=CGRectMake(j*8.f, i*20.0f, 8.0f, 20.0f);
				if(pie.screen[index]>0x1000) {
					rect=CGRectMake(j*8.f, i*20.0f, 16.0f, 20.0f);
					skipBackground=YES;
				} 
				CGContextAddRect(context,rect);
				CGContextFillRect(context,rect);
			} else {
				skipBackground=NO;
			}
			
			//CGColorRef foreground=(pie.foreground[index]==-1)?defaultBackground:colors[pie.foreground[index]];
			CGContextSetFillColorWithColor(context, defaultForeground);
			NSString *str=[NSString stringWithFormat:@"%C", pie.screen[index]];
			[str drawAtPoint:CGPointMake(j*8.0f,i*20.0f) withFont:font];
		}
	}
}

@end
