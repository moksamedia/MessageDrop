

#import "LocationController.h"
#import "GetLocationForMessage.h"

// This is a singleton class, see below
static LocationController *sharedLocationController = nil;

@implementation LocationController

@synthesize delegate, locationManager;

- (id) init {
	self = [super init];
	
	if (self != nil) 
	{
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	}
	return self;
}


- (void) start
{
	NSLog(@"Starting location services.");
	[locationManager startUpdatingLocation];
}

- (void) stop
{
	NSLog(@"Stopping location services.");
	[locationManager stopUpdatingLocation];	
}

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"Location found.");
	location = newLocation;
	[(GetLocationForMessage*)delegate newLocation: location];
	//[self locationManager: locationManager didFailWithError: [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:@"TEST ERROR!"]];
}

- (BOOL) enabled
{
	return [locationManager locationServicesEnabled];
}

// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];

	if ([error domain] == kCLErrorDomain) 
	{

		// We handle CoreLocation-related errors here

		switch ([error code]) {
			// This error code is usually returned whenever user taps "Don't Allow" in response to
			// being told your app wants to access the current location. Once this happens, you cannot
			// attempt to get the location again until the app has quit and relaunched.
			//
			// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
			// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
			//
			case kCLErrorDenied:
				[errorString appendFormat:@"%@\n", @"Location Denied - please allow Message Drop to find its location.", nil];
				[(GetLocationForMessage*)delegate locationError_Denied: (NSString*) errorString];
				break;

			// This error code is usually returned whenever the device has no data or WiFi connectivity,
			// or when the location cannot be determined for some other reason.
			//
			// CoreLocation will keep trying, so you can keep waiting, or prompt the user.
			//
			case kCLErrorLocationUnknown:
				[errorString appendFormat:@"%@\n", @"Unable to find locaiton, will keep trying.", nil];
				[(GetLocationForMessage*)delegate locationError_UnableToFind: (NSString*) errorString];
				break;

			// We shouldn't ever get an unknown error code, but just in case...
			//
			default:
				[errorString appendFormat:@"%@ %d\n", @"Location Error", [error code]];
				// Send the update to our delegate
				[(GetLocationForMessage*)delegate locationError_Other: (NSString*) errorString];
			break;
		}
	} 
	else 
	{
		// We handle all non-CoreLocation errors here
		// (we depend on localizedDescription for localization)
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
		// Send the update to our delegate
		[(GetLocationForMessage*)delegate locationError_Other: (NSString*) errorString];
	}

}

// SINGLETON 

+ (LocationController *)sharedInstance 
{
    @synchronized(self) 
	{
        if (sharedLocationController == nil) 
		{
            [[self alloc] init];
        }
    }
    return sharedLocationController;
}

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) {
        if (sharedLocationController == nil) 
		{
            sharedLocationController = [super allocWithZone:zone];
            return sharedLocationController;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
    return UINT_MAX; 
}

- (void)release 
{
    //do nothing
}

- (id)autorelease 
{
    return self;
}

@end