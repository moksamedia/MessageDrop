//
//  GetLocationForMessage.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GetLocationForMessage.h"
#import "Message_DropAppDelegate.h"
#import "Definitions.h"
#import "Network.h"

@implementation GetLocationForMessage

@synthesize gettingLocationView;
@synthesize locationFoundView;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate
{
	if ((self = [super init]))
	{
		window = _window;
		appDelegate = _appDelegate;
		
		message = nil;
		location = nil;
		
		locationController = [LocationController sharedInstance];

		previousDelegate = [locationController delegate];
		[locationController setDelegate:self];
		
		// LOAD THE NIB
		if ([[NSBundle mainBundle] loadNibNamed:@"Location" owner:self options:nil] == nil)
		{
			NSLog(@"Error! Could not load Location NIB file.\n");
		}
		
	}
	return self;
}

- (void) dealloc
{
	if (location) [location release];
	[gettingLocationView release];
	[locationFoundView release];
	[super dealloc];
}

- (void) getLocationForMessage: (Message*) _message
{
	message = _message;
	
	// start reading location
	[locationController start];
	
	[window addSubview:gettingLocationView];
	[gettingLocationActivityIndicator startAnimating];
}

- (void) newLocation: (CLLocation*) newLocation
{
	if (location) [location release];
	location = newLocation;
	[newLocation retain];
	
	[gettingLocationActivityIndicator stopAnimating];
	[gettingLocationView removeFromSuperview];
	[window addSubview: locationFoundView];

	NSString * lattitudeString = [NSString stringWithFormat:@"%f", [newLocation coordinate].latitude];
	NSString * longitudeString = [NSString stringWithFormat:@"%f", [newLocation coordinate].longitude];
	NSString * accuracyString = [NSString stringWithFormat:@"%f", [newLocation horizontalAccuracy]];
	// TODO - will have to change this back before testing!!!!
	
	//NSString * accuracyString = [NSString stringWithFormat:@"%f", 0.01];	
	[lattitudeLabel setText: lattitudeString];
	[longitudeLabel setText: longitudeString];
	[accuracyLabel setText: accuracyString];
	 
	// Set the request params
	[webView setScalesPageToFit:FALSE];
	[webView loadRequest: [GetLocationForMessage urlRequestForLocation: newLocation]];

}

/*
	Returns a NSMutableURLRequest formatted for use with the getmap.php script; used here when sending messages and when viewing messages
 */
+ (NSMutableURLRequest*) urlRequestForLocation: (CLLocation*) newLocation
{
	NSString * lattitudeString = [NSString stringWithFormat:@"%f", [newLocation coordinate].latitude];
	NSString * longitudeString = [NSString stringWithFormat:@"%f", [newLocation coordinate].longitude];
	NSString * accuracyString = [NSString stringWithFormat:@"%f", [newLocation horizontalAccuracy]];
	// TODO - will have to change this back before testing!!!!
	//NSString * accuracyString = [NSString stringWithFormat:@"%f", 0.01];
	NSString * zoomString = [NSString stringWithFormat:@"%d", DEFAULT_MAP_ZOOM_FOR_LOCATION];
		
	// CREATE REQUEST FOR WEB VIEW
	
	// String containing the url-encoded params, in this case the user name
	NSString *url = [NSString stringWithFormat: @"%@?lattitude=%@&longitude=%@&accuracy=%@&zoom=%@", GETMAP_URL, 
					 [Network urlEncodeValue:lattitudeString], 
					 [Network urlEncodeValue:longitudeString],
					 [Network urlEncodeValue:accuracyString], 
					 [Network urlEncodeValue:zoomString]];
	
	
	NSLog(url);
	

	return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
}

- (void) finish
{
	// start reading location
	[locationController stop];
	[locationController setDelegate:previousDelegate];
	previousDelegate = nil;
}

// TODO - Handle error codes

- (void) locationError_Denied: (NSString*) errorString
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Denied access to location services." message:@"Please quit program and allow access to location services." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Retry"];
	[alert show];
}

- (void) locationError_UnableToFind: (NSString*) errorString
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Unable to nail down current location." message:@"Touch cancel to quit trying or retry to continue trying to find yourself." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Retry"];
	[alert show];
}

- (void) locationError_Other: (NSString*) errorString
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error." message: errorString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Retry"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([[alertView title] isEqualToString:@"Unable to nail down current location."])
	{
		// CANCEL
		if (buttonIndex == [alertView cancelButtonIndex])
		{
			[self gettingLocationCancel];
		}
		// RETRY
		else
		{
		}
		
	}
	else
	{
		// CANCEL
		if (buttonIndex == [alertView cancelButtonIndex])
		{
			[self gettingLocationCancel];
		}
		// RETRY
		else
		{
			if (location) [location release];
			location = nil;
			
			[gettingLocationActivityIndicator stopAnimating];
			[locationController stop];
			[locationController start];
			[gettingLocationActivityIndicator startAnimating];
		}
	}
	[alertView release];
}



- (IBAction)gettingLocationCancel
{
	[gettingLocationView removeFromSuperview];
	[self finish];
	[(Message_DropAppDelegate*)appDelegate locationCanceledForMessage: message sender: self];
}

- (IBAction)locationFoundAccept
{
	[message setLocation:location];
	[locationFoundView removeFromSuperview];
	[self finish];
	[(Message_DropAppDelegate*)appDelegate locationFoundForMessage: message sender: self];
}

- (IBAction)locationFoundRetry
{
	if (location) [location release];
	location = nil;

	[locationController stop];
	[locationFoundView removeFromSuperview];
	 
	// start reading location
	[locationController start];
	
	[window addSubview:gettingLocationView];
	[gettingLocationActivityIndicator startAnimating];
}

- (IBAction)locationFoundCancel
{
	[self finish];
	[locationFoundView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate locationCanceledForMessage: message sender: self];	
}
@end
