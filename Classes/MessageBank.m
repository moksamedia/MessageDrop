//
//  MessageBank.m
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MessageBank.h"
#import "Message.h"

#define VERSION 0.5

@implementation MessageBank

@synthesize messages;

- (id) init
{
	if ((self=[super init]))
	{
		[self setMessages:[[NSMutableArray alloc] init]];
	}
	return self;
}

- (void) dealloc
{
	[messages release];
	[super dealloc];
}


- (void) encodeWithCoder: (NSCoder *) coder
{
	[coder encodeFloat: VERSION forKey:@"version"];
	[coder encodeObject: messages forKey:@"messages"];
	return;
}

- (id)initWithCoder: (NSCoder *) coder
{
	if ([coder decodeFloatForKey:@"version"] == 0.5)
	{
		[self setMessages:[coder decodeObjectForKey:@"messages"]];
	}
	return self;
}

- (void) deleteMessageAtIndex: (int) index
{
	NSAssert(index >= 0 && index < [messages count], @"Improper index!");
	[messages removeObjectAtIndex:index];
}


- (void) addMessages: (NSArray*) messagesToAdd
{
	NSAssert(messagesToAdd != nil, @"messagesToAdd == nil!");
	[messages addObjectsFromArray: messagesToAdd];
}

- (Message*) messageAtIndex: (int) index
{
	NSAssert(index >= 0 && index < [messages count], @"Improper index!");
	return [messages objectAtIndex:index];
}

- (int) numberOfMessages
{
	return [messages count];
}

- (int) unlockMessagesForLocation: (CLLocation*) currentLocation
{
	double hitToleranceInMeters;
	Message * message;
	int unlockedMessages = 0;
	
	int i;
	for (i=0;i<[messages count];i++)
	{
		message = [messages objectAtIndex:i];
		hitToleranceInMeters = [message hitToleranceInMeters];
		if (hitToleranceInMeters > [[message location] getDistanceFrom:currentLocation])
		{
			[message setLocked:0];// FALSE
			unlockedMessages++;
		}
	}

	return unlockedMessages;
}


@end
