

// Class definition
@interface LocationController: NSObject <CLLocationManagerDelegate> 
{
	CLLocationManager *locationManager;
	id delegate;
	CLLocation * location;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (assign) id delegate;

- (void) start;
- (void) stop;
- (BOOL) enabled;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

+ (LocationController *)sharedInstance;

@end

