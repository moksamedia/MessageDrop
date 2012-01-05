//
//  GetLocationForMessage.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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