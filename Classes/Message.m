//
//  Message.m
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

#import "Message.h"

#define VERSION 0.5


@implementation Message

@synthesize messageText;
@synthesize hint;
@synthesize receiver;
@synthesize sender;
@synthesize hasBeenRead;
@synthesize hidden;
@synthesize locked;
@synthesize lattitude_degrees;
@synthesize lattitude_minutes;
@synthesize lattitude_seconds;
@synthesize longitude_degrees;
@synthesize longitude_minutes;
@synthesize longitude_seconds;
@synthesize hitToleranceInMeters;
@synthesize location;

- (id) initWithMessageText: (NSString*) _messageText hint: (NSString*) _hint receiver: (NSString*) _receiver sender: (NSString*) _sender hasBeenRead: (int) _hasBeenRead hidden: (int) _hidden location: (CLLocation *) _location hitToleranceInMeters: (float) tolerance locked: (int) _locked
{
	if ( (self = [super init]) )
	{
		[self setMessageText:_messageText];
		[self setHint:_hint];
		[self setReceiver:_receiver];
		[self setSender:_sender];
		[self setHasBeenRead:_hasBeenRead];
		[self setHidden:_hidden];
		[self setLocation:_location];
		[self setHitToleranceInMeters:tolerance];
		[self setLocked:_locked];
		
		NSLog(@"Creating Message:::");
		[self pushToLog];
	}
	return self;
}

- (void) pushToLog
{
	NSLog(@"messageText = %@, hint = %@, receiver = %@, sender = %@, hasBeenRead = %d, hidden = %d, lattitude = %f, longitude = %f, hitToleranceInMeters = %f, locked = %d", 
		  messageText, hint, receiver, sender, hasBeenRead, hidden, [location coordinate].latitude, [location coordinate].longitude, hitToleranceInMeters, locked);	
}

- (void) dealloc
{
	[messageText release];
	[receiver release];
	[sender release];
	[hint release];
	[location release];
	[super dealloc];
}

- (void) encodeWithCoder: (NSCoder *) coder
{
	[coder encodeFloat: VERSION forKey:@"version"];

	[coder encodeObject: messageText forKey:@"messageText"];
	[coder encodeObject: sender forKey:@"sender"];
	[coder encodeObject: receiver forKey:@"receiver"];
	[coder encodeObject: hint forKey:@"hint"];

	[coder encodeObject: location forKey:@"location"];

	[coder encodeInt: hasBeenRead forKey:@"hasBeenRead"];
	[coder encodeInt: hidden forKey:@"hidden"];
	[coder encodeInt: locked forKey:@"locked"];

	[coder encodeDouble: hitToleranceInMeters forKey:@"hitToleranceInMeters"];
	return;
}

- (id)initWithCoder: (NSCoder *) coder
{

	if ([coder decodeFloatForKey:@"version"] == 0.5)
	{
		[self setMessageText:[coder decodeObjectForKey:@"messageText"]];
		[self setSender:[coder decodeObjectForKey:@"sender"]];
		[self setReceiver:[coder decodeObjectForKey:@"receiver"]];
		[self setHint:[coder decodeObjectForKey:@"hint"]];
		[self setLocation:[coder decodeObjectForKey:@"location"]];
		
		[self setHidden:[coder decodeIntForKey:@"hidden"]];
		
		[self setHasBeenRead:[coder decodeIntForKey:@"hasBeenRead"]];
		[self setLocked:[coder decodeIntForKey:@"locked"]];
		
		[self setHitToleranceInMeters:[coder decodeDoubleForKey:@"hitToleranceInMeters"]];
	
	}
	return self;
}

- (NSString*) stringForTableViewCell
{
	if ([self locked] == 0) // is hidden
	{
		return [NSString stringWithFormat:@"From: %@ - %@", [self sender], [self messageText]]; 		
	}
	else
	{
		return [NSString stringWithFormat:@"LOCKED!!!"]; 
	}
}


/*
	Degrees spans from -180 to +180
 */
- (void) setLongitudeWithDegrees: (double) longitude
{
	int degrees;
	int minutes;
	double minutes_float;
	double seconds;
	double dummy;
	
	degrees = (int)trunc(longitude);
	minutes_float = modf(longitude, &dummy) * 60.0;
	minutes = (int)trunc(minutes_float);
	seconds = modf(minutes_float, &dummy) * 60.0;
		

	[self setLongitude_degrees:degrees];
	[self setLongitude_minutes:minutes];
	[self setLongitude_seconds:seconds];
}

- (void) setLattitudeWithDegrees: (double) lattitude
{
	int degrees;
	int minutes;
	double minutes_float;
	double seconds;
	double dummy;
	
	degrees = (int)trunc(lattitude);
	minutes_float = modf(lattitude, &dummy) * 60.0;
	minutes = (int)trunc(minutes_float);
	seconds = modf(minutes_float, &dummy) * 60.0;
	
	[self setLattitude_degrees:degrees];
	[self setLattitude_minutes:minutes];
	[self setLattitude_seconds:seconds];
	
}

- (void) setLattitudeAndLongitudeWithCoordinate: (CLLocationCoordinate2D) coordinate
{
	[self setLongitudeWithDegrees: coordinate.longitude];
	[self setLattitudeWithDegrees: coordinate.latitude];
}

- (void) setLocation: (CLLocation*) newLocation;
{
	if (location != nil) [location release];
	location = newLocation;
	[location retain];
	[self setLattitudeAndLongitudeWithCoordinate: [location coordinate]];
}

@end
