//
//  PieView.m
//  Pie
//
//  Created by Jong Wook Kim on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PieView.h"

static int rows=24;
static int cols=80;

@implementation PieView

-(void)didMoveToSuperview {
	// initialization
	encoding=-2147482590;	// cp949
	font=[UIFont fontWithName:@"Courier" size:16.0f];
	NSLog(@"PieView Initialized");
	
}

static const char *kor[]={"가","나","다","라","마","바","사","아"};

-(void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	
	for (int i=0;i<rows;i++) {
		for(int j=0;j<cols;j++) {
			if (i%2==0) {
				NSString *str=[NSString stringWithFormat:@"%c", 'A'+j];
				[str drawAtPoint:CGPointMake(j*8.0f,i*20.0f) withFont:font];
			} else if(j%2==0) {
				NSString *str=[NSString stringWithUTF8String:kor[(j/2)%8]];
				[str drawAtPoint:CGPointMake(j*8.0f,i*20.0f) withFont:font];
			}
		}
	}
}
@end
