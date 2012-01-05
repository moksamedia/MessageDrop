//
//  MessageBank.h
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"


@interface MessageBank : NSObject
{
	NSMutableArray * messages;  // the array of message objects;
}

@property (retain) NSMutableArray * messages;

- (void) addMessages: (NSArray*) messagesToAdd;
- (void) deleteMessageAtIndex: (int) index;
- (Message*) messageAtIndex: (int) index;
- (int) numberOfMessages;
- (int) unlockMessagesForLocation: (CLLocation*) currentLocation;

@end
