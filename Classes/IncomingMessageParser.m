//
//  IncomingMessageParser.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
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

#import "IncomingMessageParser.h"
#import "Message.h"


@implementation IncomingMessageParser

- (id) init
{
		if ( (self = [super init]) )
		{
			numberOfMessages = 0;
			parsedMessages = [[NSMutableArray alloc] init];
			
			// Number formatter used to parse program numbers entered into combo boxes
			numberFormatter = [[NSNumberFormatter alloc] init];
			[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			//[numberFormatter setFormat:@"0"];			
		}
	return self;
}

- (void) dealloc
{
	[parsedMessages release];
	[parser release];
	[numberFormatter release];
	[super dealloc];
}

- (int) numberOfMessages
{
	return numberOfMessages;
}

- (NSArray *) parsedMessages
{
	return parsedMessages;
}

- (BOOL)parseXMLData:(NSData *)incomingMessageData 
{
    parser = [[NSXMLParser alloc] initWithData:incomingMessageData];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    return [parser parse]; // return value not used
}

// NSXMLPARSER DELEGATE METHODS

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
	NSLog(@"Starting element: %@", elementName);

    if ( [elementName isEqualToString:@"xml"]) 
	{
		numberOfMessages = [[numberFormatter numberFromString:[attributeDict objectForKey:@"numberOfMessages"]] intValue];
        return;
    }
	else if ( [elementName isEqualToString:@"message"]) 
	{
		NSAssert(currentMessage == nil, @"current message != nil (maybe XML poorly formed?)");
		
		// SENDER
		NSString * sender = [attributeDict objectForKey:@"sender"];
		NSAssert([sender length] > 0, @"sender attribute wrong!");

		// RECEIVER
		NSString * receiver = [attributeDict objectForKey:@"receiver"];
		NSAssert([receiver length] > 0, @"receiver attribute wrong!");

		// MESSAGETEXT
		NSString * messageText = [attributeDict objectForKey:@"messageText"];
		NSAssert(messageText != nil, @"messageText = nil!");

		// HINT
		NSString * hint = [attributeDict objectForKey:@"hint"];
		NSAssert(hint != nil, @"hint = nil!");

		// HASBEENREAD
		NSString * _hasBeenRead = [attributeDict objectForKey:@"hasBeenRead"];
		NSAssert(_hasBeenRead != nil, @"hasBeenRead = nil!");
		int hasBeenRead = [[numberFormatter numberFromString:_hasBeenRead] intValue];

		// HIDDEN
		NSString * _hidden = [attributeDict objectForKey:@"hidden"];
		NSAssert(_hidden != nil, @"hidden = nil!");
		int hidden = [[numberFormatter numberFromString:_hidden] intValue];

		// LATTITUDE
		NSString * _lattitude = [attributeDict objectForKey:@"lattitude"];
		NSAssert(_lattitude != nil, @"lattitude = nil!");
		float lattitude = [[numberFormatter numberFromString: _lattitude] floatValue];

		// LONGITUDE
		NSString * _longitude = [attributeDict objectForKey:@"longitude"];
		NSAssert(_longitude != nil, @"longitude = nil!");
		float longitude = [[numberFormatter numberFromString: _longitude] floatValue];

		// HITTOLERANCEINMETERS
		NSString * _hitToleranceInMeters = [attributeDict objectForKey:@"hitToleranceInMeters"];
		NSAssert(_hitToleranceInMeters != nil, @"hitToleranceInMeters = nil!");
		float hitToleranceInMeters = [[numberFormatter numberFromString: _hitToleranceInMeters] floatValue];
		
		// HIDDEN
		NSString * _locked = [attributeDict objectForKey:@"locked"];
		NSAssert(_locked != nil, @"locked = nil!");
		int locked = [[numberFormatter numberFromString:_locked] intValue];

		CLLocation * location = [[CLLocation alloc] initWithLatitude:(double)lattitude longitude:(double)longitude];
		
   		currentMessage = [[Message alloc] initWithMessageText:messageText hint:hint receiver:receiver sender:sender hasBeenRead:hasBeenRead hidden:hidden location:location hitToleranceInMeters:hitToleranceInMeters locked:locked];

		[location release];
		
		return;
    }
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
 	NSLog(@"Ending element: %@", elementName);
	if ( [elementName isEqualToString:@"message"]) 
	{
		[parsedMessages addObject:currentMessage];
		[currentMessage release];
		currentMessage = nil;
        return;
    }
  
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSAssert(numberOfMessages == [parsedMessages count], @"Parser error!");
}

@end
