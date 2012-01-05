//
//  MessageBank.m
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
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
