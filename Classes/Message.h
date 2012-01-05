//
//  Message.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

/*
	TO ADD NEW ITEM TO MESSAGE:
	- change in this class:
		- add to constructor here and in implementation
		- also add to initWithCoder and encodeWithCoder (update version, if necessary)
		- add variable declaration, @property, and @synthesize (with retain or assign or nothing, as appropriate)
		- update pushToLog
		- CreateNewMessage
				- have to deal with how the new item is assigned when a new message is created
		- SendMessage
				- add new item to makePostRequestForMessage:
					- make sure to create the new item instance variable, and assing the "name" and the value in the post string
		- sendmessage.phhp
				- create new instance variable and get from $_POST
				- add to database query
				- add to error output
		- database
				- have to add the actual entry into the database
		- checkmail.php
				- add a new $message->addAttribute() in the XML
		- IncomingMessageParser
				- add a new element in the "didStartElement" method
				- also update the new message constructor
 */

@interface Message : NSObject 
{
	NSString * messageText;
	NSString * sender;
	NSString * receiver;
	NSString * hint;
	
	int hasBeenRead;
	int locked;
	int hidden;

	int lattitude_degrees;
	int lattitude_minutes;
	double lattitude_seconds;

	int longitude_degrees;
	int longitude_minutes;
	double longitude_seconds;
	
	CLLocation * location;
	
	double hitToleranceInMeters;
}
- (id) initWithMessageText: (NSString*) _messageText 
					hint: (NSString*) _hint 
					receiver: (NSString*) _receiver 
					sender: (NSString*) _sender 
					hasBeenRead: (int) _hasBeenRead 
					hidden: (int) _hidden 
					location: (CLLocation *) _location 
					hitToleranceInMeters: (float) _tolerance
					locked: (int) _locked;

- (void) setLongitudeWithDegrees: (double) degrees;
- (void) setLattitudeWithDegrees: (double) degrees;
- (void) setLattitudeAndLongitudeWithCoordinate: (CLLocationCoordinate2D) coordinate;
- (void) pushToLog;

- (NSString*) stringForTableViewCell;

@property (retain) NSString * messageText;
@property (retain) NSString * hint;
@property (retain) NSString * sender;
@property (retain) NSString * receiver;

@property int hasBeenRead;
@property int hidden;
@property int locked;

@property int lattitude_degrees;
@property int lattitude_minutes;
@property double lattitude_seconds;

@property int longitude_degrees;
@property int longitude_minutes;
@property double longitude_seconds;

@property (retain) CLLocation * location;

@property double hitToleranceInMeters;







@end
