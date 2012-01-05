//
//  CreateNewUser.m
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

#import "CreateNewUser.h"
#import "Message_DropAppDelegate.h"
#import "Definitions.h"


@implementation CreateNewUser

@synthesize chooseUserNameView;
@synthesize choosePasswordAndFinishView;
@synthesize connectingToServerView;
@synthesize userName;
@synthesize password;
@synthesize emailAddress;

enum  {
	CHOOSINGUSERNAME = 0,
	CHOOSINGPASSWORD = 1
};

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate
{
	if ((self = [super init]))
	{
		window = _window;
		appDelegate = _appDelegate;
		createNewAccount = nil;
		state = CHOOSINGUSERNAME;
		// LOAD THE NIB
		if ([[NSBundle mainBundle] loadNibNamed:@"CreateNewUser2" owner:self options:nil] == nil)
		{
			NSLog(@"Error! Could not load CreateNewUser NIB file.\n");
		}
		
		[provisionalUserName setDelegate:self];
		[choosePasswordTextField setDelegate:self];
		[confirmPasswordTextField setDelegate:self];
		[emailAddressTextField setDelegate:self];
		[yourNewUserNameIsTextField setDelegate:self];
		
		isUserNameTaken = [[IsUserNameTaken alloc] initForAppDelegate:self];
	}
	return self;
}

- (void) go
{
	[window addSubview: chooseUserNameView];
}

- (IBAction) cancel: (id) sender
{
	[chooseUserNameView removeFromSuperview];
	[appDelegate createNewUserDidCancel:self];
}

- (void) dealloc
{
	[chooseUserNameView release];
	[choosePasswordAndFinishView release];
	[isUserNameTaken release];
	[connectingToServerView release];
	if (createNewAccount != nil) [createNewAccount release];
	[super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// if user cancels while waiting on response from server

- (IBAction) connectingToServerCancel: (id) sender
{
	
	[connectingToServerView removeFromSuperview];
	[activityIndicator stopAnimating];
	
	if (state == CHOOSINGUSERNAME) [window addSubview:chooseUserNameView];
	else [window addSubview:choosePasswordAndFinishView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Choosing the username

- (IBAction) chooseUserNameCancel: (id) sender
{
	[(Message_DropAppDelegate*)appDelegate createNewUserDidCancel: self];
}

- (IBAction) chooseUserNameOK: (id) sender
{
	
	// VERIFY THAT USER NAME CONTAINS NO SPECIAL CHARACTERS
	if ([CreateNewUser validateProposedUserName: [provisionalUserName text]])
	{
		[chooseUserNameView removeFromSuperview];
		[window addSubview:connectingToServerView];
		[activityIndicator startAnimating];

		// RUN CHECK WITH SERVER SCRIPT HERE TO OK USER NAME
		[isUserNameTaken checkIfUserNameIsTaken:[provisionalUserName text]];
	}
}

+ (BOOL) validateProposedUserName: (NSString*) user
{

	if ([user length] < 1)
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"User name cannot be blank!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return FALSE;
	}
	
	NSCharacterSet * illegalCharSet = [[NSCharacterSet characterSetWithCharactersInString:ILLEGALCHARACTERS] retain];

	NSRange result = [user rangeOfCharacterFromSet: illegalCharSet];
	NSRange result2 = [user rangeOfCharacterFromSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[illegalCharSet release];

	if (result.location == NSNotFound && result2.location == NSNotFound)
	{
		return TRUE;
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Illegal Characters in Username!" message:@"No whitespace (space, tab, return) or disallowed characters: * . / \\" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return FALSE;
	}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Delegate routines from IsUserNameTaken object (which handles the network connection and querying the database server)

// called by IsUserNameTaken when response is received from server, name is TAKEN
- (void) userNameTaken
{
	[connectingToServerView removeFromSuperview];
	[activityIndicator stopAnimating];
	[window addSubview:chooseUserNameView];
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sorry, user name is taken. Please try again." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// called by IsUserNameTaken when response is received from server, name is NOT TAKEN
- (void) userNameNotTaken
{
	
	state = CHOOSINGPASSWORD;
	
	// switch out the views
	[connectingToServerView removeFromSuperview];
	[activityIndicator stopAnimating];
	[window addSubview:choosePasswordAndFinishView];
	
	// set the user name text field, and make it disabled
	[yourNewUserNameIsTextField setText:[provisionalUserName text]];
	[yourNewUserNameIsTextField setEnabled:FALSE];
	
}

// called by IsUserNameTaken when request is sent to server
- (void) isUserNameTakenRequestSent
{
	
}

// called by IsUserNameTaken when error is encountered
- (void) isUserNameTakenError: (NSString*) errorString
{
	NSLog(errorString);
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  After username is chosen and validted, must choose password and email address and send to server

- (IBAction) choosePasswordAndFinishCancel: (id) sender
{
	[choosePasswordAndFinishView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate createNewUserDidCancel: self];	
}

- (IBAction) choosePasswordAndFinishOK: (id) sender
{
	
	// make sure password doesn't contain any illegal characters
	if ([CreateNewUser validatePassword: [choosePasswordTextField text]])  // make sure the password doesnt have any illegal characters
	{
	
		// make sure passwords match
		if (![[choosePasswordTextField text] isEqualToString: [confirmPasswordTextField text]]) // make sure the passwords match
		{
			UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Entered passwords do not match!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];			
		}
		else
		{
				if ([[emailAddressTextField text] isEqualToString:@""])
				{
					UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please enter a valid email address!" message:@"Without an email address, we cannot reset your password if forgotten or lost." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
					[alert release];												
				}
				else
				{
					[choosePasswordAndFinishView removeFromSuperview];
					[window addSubview:connectingToServerView];
					[activityIndicator startAnimating];
					
					createNewAccount = [[CreateNewAccount alloc] initForAppDelegate:self];
					[createNewAccount createNewAccountForUser:[provisionalUserName text] password:[choosePasswordTextField text] email:[emailAddressTextField text]];
				}
		}
	}
}


+ (BOOL) validatePassword: (NSString*) passwd
{
	
	if ([passwd length] < MINPASSWORDLENGHT)
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Passwords must be at least 5 characters long!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];	
		return FALSE;
	}
	
	NSCharacterSet * illegalCharSet = [[NSCharacterSet characterSetWithCharactersInString:ILLEGALCHARACTERS] retain];
	
	NSRange result = [passwd rangeOfCharacterFromSet: illegalCharSet];
	NSRange result2 = [passwd rangeOfCharacterFromSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[illegalCharSet release];
	
	if (result.location == NSNotFound && result2.location == NSNotFound)
	{
		return TRUE;
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Illegal characters in password!" message:@"Disallowed characters: * . / \\" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return FALSE;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Delegate routines from CreateNewAccount object (which handles the network connection and inserting the new user info into the database)

// called by CreateNewAccount when request is sent to server
- (void) createNewUserRequestSent
{
	
}

// called by CreateNewAccount when error is encountered
- (void) createNewUserError: (NSString*) errorString
{
	NSLog(errorString);
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sorry, there was an error trying to create the account." message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[connectingToServerView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate createNewUserDidCancel: self];
}

- (void) createNewUserSuccess
{																									
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message Drop Account Created." message:[NSString stringWithFormat:@"USER = %@, PASSWORD = %@", [provisionalUserName text], [choosePasswordTextField text]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[self setPassword:[choosePasswordTextField text]];
	[self setUserName:[provisionalUserName text]];
	[self setEmailAddress:[emailAddressTextField text]];
	
	[connectingToServerView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate createNewUserDidFinish: self];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UITextField Delegate Routines

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
	[textField resignFirstResponder];  // this makes the keyboard go away when the user hits return
	return TRUE;
}

@end
