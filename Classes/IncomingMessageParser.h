//
//  IncomingMessageParser.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IncomingMessageParser : NSObject 
{
	NSXMLParser * parser;
	id currentMessage;
	
	int numberOfMessages;
	NSMutableArray * parsedMessages;
	
	NSNumberFormatter * numberFormatter;
}

- (BOOL)parseXMLData:(NSData *)incomingMessageData;
- (int) numberOfMessages;
- (NSArray *) parsedMessages;

@end
