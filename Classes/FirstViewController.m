//
//  FirstViewController.m
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "FirstViewController.h"
#import "Message.h"


@implementation FirstViewController


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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}
*/

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


- (IBAction) deleteMessage: (id) sender
{
	
}

- (IBAction) replyMessage: (id) sender
{
	
}

- (IBAction) showMessage: (id) sender
{
	
}

- (IBAction) createNewMessage: (id) sender
{
	[appDelegate createNewMessage];
}

- (IBAction) checkMessages: (id) sender
{
	[appDelegate checkMessages];
}


- (void) setTableViewDataSource: (id) newDataSource
{
	[tableView setDataSource:newDataSource];
}

- (void) reloadData
{
	[tableView reloadData];
}

- (IBAction) openPreferences: (id) sender
{
	[appDelegate openPreferences];
}




@end
