//
//  GetLocationForMessage.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/6/09.
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

#import "LocationController.h"
#import "Message.h"

@interface GetLocationForMessage : NSObject 
{

	LocationController * locationController;
	
	UIWindow * window;
	id appDelegate;
	id previousDelegate;

	Message * message;
	CLLocation * location;
	
	UIView *gettingLocationView;
	
	IBOutlet UILabel * gettingLocationLabel;
	IBOutlet UILabel * unlockMessagesLabel;
	
	IBOutlet UIActivityIndicatorView *gettingLocationActivityIndicator;
	UIView *locationFoundView;	
	IBOutlet UILabel *accuracyLabel;
	IBOutlet UILabel *lattitudeLabel;
	IBOutlet UILabel *longitudeLabel;
	IBOutlet UIWebView * webView;
	
}

@property (retain) IBOutlet UIView *gettingLocationView;
@property (retain) IBOutlet UIView *locationFoundView;


- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate;
- (void) getLocationForMessage: (Message*) _message;
- (CLLocation*) currentLocation;
- (void) finish;


// action methods for location views
- (IBAction)gettingLocationCancel;
- (IBAction)locationFoundAccept;
- (IBAction)locationFoundRetry;
- (IBAction) locationFoundCancel;

// delegate methods for LocationController
- (void) newLocation: (CLLocation*) newLocation;
- (void) locationError_Denied: (NSString*) errorString;
- (void) locationError_UnableToFind: (NSString*) errorString;
- (void) locationError_Other: (NSString*) errorString;

// returns a URL request for a given location (GET request)
+ (NSMutableURLRequest*) urlRequestForLocation: (CLLocation*) newLocation;

@end
