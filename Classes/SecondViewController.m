//
//  SecondViewController.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "Message.h"

@implementation SecondViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	scrollView.contentSize = CGSizeMake(0, 800);
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) dropNewMessage: (id) sender
{
	NSLog(@"Dropping new message!");
	Message * newMessage = [[Message alloc] initWithMessageText:@"A NEW MESSAGE TEXT" 
														   hint:@"HERES A HINT" 
													   receiver:@"andrewhughes" 
														 sender:@"asender" 
													hasBeenRead:0 
														 hidden:0
													   location:[[CLLocation alloc] initWithLatitude:45.1111 longitude:55.2222] 
										  hitToleranceInSeconds:34.0];
	[appDelegate sendMessage: newMessage];
}

@end
