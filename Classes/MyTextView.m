//
//  MyTextView.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/3/09.
//
//    -------------------------------------------
//
//
//    All code (c)2009 Moksa Media all rights reserved
//    Developer: Andrew Hughes
//
//    This file is part of MessageDrop.
//
//    MessageDrop is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MessageDrop is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MessageDrop.  If not, see <http://www.gnu.org/licenses/>.
//
//
//    -------------------------------------------
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
