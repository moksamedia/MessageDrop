//
//  EditPreferences.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
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

#import "EditPreferences.h"
#import "CreateNewUser.h"
#import "Message_DropAppDelegate.h"

@implementation EditPreferences

//@synthesize view;
@synthesize contentView;
@synthesize topView;
@synthesize changeUserView;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate
{
	if ((self = [super init]))
	{
		window = _window;
		appDelegate = _appDelegate;

		createNewUser = nil;  // don't make this until we need it
		
		// LOAD THE NIB
		if ([[NSBundle mainBundle] loadNibNamed:@"Preferences" owner:self options:nil] == nil)
		{
			NSLog(@"Error! Could not load EditPreferences NIB file.\n");
		}
		
		// need this so that keyboard will go away when return it pressed
		[ipAddressTextField setDelegate:self];
		[usernameTextField setDelegate:self];
		[passwordTextField setDelegate:self];
		[changeUserUsernameTextField setDelegate:self];
		[changeUserPasswordTextField setDelegate:self];
		
		// get the current vaules from the defaults
		userName =  [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERNAME];
		password = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_PASSWORD];
		ipAddress = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_IPADDRESS];

		// set the values to the 
		[ipAddressTextField setText: ipAddress];
		[usernameTextField setText: userName];
		[passwordTextField setText: password];
		
		scrollView.contentSize = CGSizeMake(320, 480);
		[scrollView addSubview:contentView];

	}
	return self;
}
- (void) dealloc
{
	
	[topView release];
	[contentView release];
	[changeUserView release];
	[super dealloc];
}

- (void) go
{
	[window addSubview:topView];
}


- (IBAction) OK: (id) sender
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	[topView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate editPreferencesFinished:self];				
}

- (IBAction) cancel: (id) sender
{
	[topView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate editPreferencesFinished:self];	
}

- (IBAction) changeUser: (id) sender
{
	[scrollView removeFromSuperview];
	[topView addSubview:changeUserView];
	[topView sendSubviewToBack:changeUserView];
}

- (IBAction) changeUserOK: (id) sender
{
	if ([CreateNewUser validateProposedUserName:[changeUserUsernameTextField text]] && [CreateNewUser validatePassword:[changeUserPasswordTextField text]])
	{

		// set the local variables
		userName = [changeUserUsernameTextField text];
		password = [changeUserPasswordTextField text];
		// set the variables in the appDelegate (which sets the user defaults)
		[appDelegate setUserName: userName];
		[appDelegate setPassword: password];
		// change the text fields
		[usernameTextField setText: userName];
		[passwordTextField setText: password];

		[changeUserView removeFromSuperview];
		[window addSubview:scrollView];
	}
}

- (IBAction) changeUserCancel: (id) sender
{
	[changeUserView removeFromSuperview];
	[window addSubview:scrollView];
}

- (IBAction) createNewAccount: (id) sender
{
	createNewUser = [[CreateNewUser alloc] initForWindow: window appDelegate: self];
	[topView removeFromSuperview];
	[createNewUser go];
}

- (void) createNewUserDidFinish: (id) sender
{	
	// set the local variables
	userName = [createNewUser userName];
	password = [createNewUser password];
	// set the variables in the appDelegate (which sets the user defaults)
	[appDelegate setUserName: userName];
	[appDelegate setPassword: password];
	// change the text fields
	[usernameTextField setText: userName];
	[passwordTextField setText: password];
	// release the CreateNewUser object
	[sender release];
	// update the view
	[window addSubview:topView];
}

- (void) createNewUserDidCancel: (id) sender
{
	[sender release];
	[window addSubview:topView];
}

- (IBAction) editIPAddress: (id) sender
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to change the IP address?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// CANCEL
	if (buttonIndex == [alertView cancelButtonIndex])
	{
		ipAddress = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_IPADDRESS];
		[ipAddressTextField setText: ipAddress];	
	}
	// GO AHEAD AND CHANGE IT
	else
	{
		ipAddress = [ipAddressTextField text];
		[[NSUserDefaults standardUserDefaults] setObject:ipAddress forKey:DEFAULTS_IPADDRESS];
	}
	[alertView release];
}


- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
	[textField resignFirstResponder];  // this makes the keyboard go away when the user hits return
	return TRUE;
}

// moves the text views up when the keyboard appears
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//int offset = 0;
	if (textField == ipAddressTextField)
	{
		int offset = 200;
		CGPoint pt ;
		CGRect textViewBounds = [textField bounds];
		CGRect convertedBounds = [textField convertRect:textViewBounds toView:scrollView];
		pt = convertedBounds.origin ;
		pt.x = 0 ;
		pt.y = offset;
		[scrollView setContentOffset:pt animated:YES];	
	}

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//int offset = 0;
	if (textField == ipAddressTextField)
	{
		int offset = 0;
		CGPoint pt ;
		CGRect textViewBounds = [textField bounds];
		CGRect convertedBounds = [textField convertRect:textViewBounds toView:scrollView];
		pt = convertedBounds.origin ;
		pt.x = 0 ;
		pt.y = offset;
		[scrollView setContentOffset:pt animated:YES];	
	}
}





@end
