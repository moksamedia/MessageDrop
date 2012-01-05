//
//  MyTextView.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyTextView.h"


@implementation MyTextView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

// adds a border to the text box
- (void)drawRect:(CGRect)clip
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, false);
	
	CGContextSetRGBStrokeColor(context,0.0,0.0,0.0,0.9);
	CGContextBeginPath(context);
	
	float maxX = CGRectGetMaxX(clip) - 1.0;
	float maxY = CGRectGetMaxY(clip) - 1.0;
	float minX = CGRectGetMinX(clip) + 1.0;
	float minY = CGRectGetMinY(clip) + 1.0;
	
	CGContextMoveToPoint(context, minX, minY);
	CGContextAddLineToPoint(context, maxX, minY);
	CGContextAddLineToPoint(context, maxX, maxY);
	CGContextAddLineToPoint(context, minX, maxY);
	CGContextAddLineToPoint(context, minX, minY);
	CGContextStrokePath(context);
	CGContextSetAllowsAntialiasing(context, true);
} 

 
- (void)dealloc {
    [super dealloc];
}


@end
