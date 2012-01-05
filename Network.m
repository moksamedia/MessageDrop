//
//  Network.m
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Network.h"
#import "CheckMessages.h"
#import "SendMessages.h"




@implementation Network


+ (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	return [result autorelease];
}
@end
