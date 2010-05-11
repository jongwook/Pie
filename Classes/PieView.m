//
//  PieView.m
//  Pie
//
//  Created by Jong Wook Kim on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PieView.h"


@implementation PieView

-(void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
	
	CGRect currentRect=CGRectMake(100,100,200,200);
	CGContextAddRect(context, currentRect);
	CGContextDrawPath(context, kCGPathFillStroke);
}

@end
