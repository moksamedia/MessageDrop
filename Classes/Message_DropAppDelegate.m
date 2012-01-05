//
//  Message_DropAppDelegate.m
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

/*
	TODO:
 
 *** REMEMBER TO CHANGE ACCURACY IN GETLOCATIONFORMESSAGE BECAUSE IT IS HARD CODED FOR TESTING
	 ALSO NEED TO CHANGE URLS AND REGISTER WITH GOOGLE FOR MAPS AND CHANGE AUTH CODE IN SCRIPT
 
	CHECK MESSAGES ON OPENING
 
	DEAL WITH MODES: NO GPS, NO INTERNET
 
	Mark unread messages with color?  Blue on white vs white on blue?
 
	Error message logging to server (ie, send an error message to server when user encoutners an error)
 
	SERVER RULES - messages kept on server for one week after first read, unread messages are deleted after one month
	
 
	When user tries to send message, verify that the user they are sending it to exists (suggest completions from previous senders?)
	*** implement as drop down box with previous (10?) recipeints available?
 
	- when message is locked, show a scrambled version of it, and maybe flash the real message or something
	- convert data to (gzip'ed) xml file, only keep name and location on server as native data
	- more graceful error handling: use XML error codes from scripts that print out on sheets
	- compressing of saved messages
	- send data to server in compressed data format.  only needed information available.  sender, receiver, location
		- or maybe not, because this would make it harder to support other platforms
	- import contacts and invite friends to join
	- contacts list
	- location coding
	- saving locations
	- ability to save drafts, esp. on error, or when location not available
	- manually enter location
	- google map server for locations
	- multiple recipeints
	- check if recipeint exits, if not, return message and give user chance to edit
	- received messages are deleted from database (send index with message, then send index back of received messages)
	*** losing data when exiting simulator without quitin
 
 */
#import "Message_DropAppDelegate.h"
#import "Network.h"
#import "FirstViewController.h"
#import "CheckMessages.h"
#import "SendMessages.h"
#import "CreateNewUser.h"
#import "CreateNewMessage.h"
#import "Message.h"
#import "GetLocationForMessage.h"
#import "Definitions.h"
#import "EditPreferences.h"
#import "ViewMessage.h"
#import "GetLocation.h"

@implementation Message_DropAppDelegate

@synthesize window;
@synthesize mainView;
@synthesize messageBank;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	locationController = [LocationController sharedInstance];

	if (![locationController enabled])
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location services are not enabled." message:@"Please quit program and enable." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];				
	}
	
	// if the program has been run before, ie not the first time
	if ([[NSUserDefaults standardUserDefaults] boolForKey:DEFAULTS_HASBEENRUN])
	{
		// then load the saved messageBank
		if (![self openSavedData]) 
		{
			UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Unable to load saved messages from disk." message:@"Initializing new save file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];		
			[self setMessageBank:[[MessageBank alloc] init]];					
		}
	}
	// being run for first time
	else
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:DEFAULTS_HASBEENRUN];
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithString: DEFAULTIPADDDRESS] forKey:DEFAULTS_IPADDRESS];
		[self setMessageBank:[[MessageBank alloc] init]];		
	}
	
	// see if a username is set in defaults, if not, create a new user
	if (![[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERNAME])
	{
		CreateNewUser * createNewUser = [[CreateNewUser alloc] initForWindow: window appDelegate: self];
		[createNewUser go];
	}
	else
	{
		// Add the tab bar controller's current view as a subview of the window
		[window addSubview:mainView];
	}
		
	[messageTableView setDataSource:self];
	[messageTableView setDelegate:self];
	[window makeKeyAndVisible];
}

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */

- (void)applicationWillTerminate:(UIApplication *)application
{
	if(![self saveData])
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Unable to save messages to disk." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
}

- (void)dealloc 
{
    [mainView release];
	[messageBank release];
    [window release];
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// TABLE VIEW DATA SOURCE METHODS

// Returns a table view cell for a given row in the table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// check with the table view to see if there is a cell marked for reuse
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	// if not, make a new one
	if (cell == nil) cell = [[UITableViewCell alloc] init];
	
	// get the row of the item from the indexpath
	unsigned int index = [indexPath row];
	
	Message * message = [messageBank  messageAtIndex:index];	
	// set the cell text
	[cell setText:[message stringForTableViewCell]];
	[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	
	// return the cell
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [messageBank numberOfMessages];
}

// TABLE VIEW DELEGATE METHOD - accessory view for opening message
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[[ViewMessage alloc] initForWindow:window appDelegate:self message:[messageBank messageAtIndex:[indexPath row]]];
}

- (void) viewMessageFinish: (id) sender
{
	[sender release];
	[window addSubview: mainView];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// SAVE AND LOAD

- (BOOL) openSavedData
{
	NSString * path = [NSString stringWithFormat:@"%@/Documents/MessageDrop_SavedData", NSHomeDirectory()]; 
	
	NSMutableData * data = [NSData dataWithContentsOfFile:path];
	
	if (data == NULL) 
	{
		return FALSE;
	}
	
	NSKeyedUnarchiver *unarchiver;
	
	unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	MessageBank * _messageBank = [[unarchiver decodeObjectForKey:@"messageBank"] retain];
	
	NSAssert(_messageBank != nil, @"Unable to load messageBank from save file!");
	
	if (_messageBank == nil)
	{
		return FALSE;
	}
	
	[self setMessageBank:_messageBank];
 
	[unarchiver finishDecoding];
	[unarchiver release]; 
	
	return TRUE;
	
}


- (BOOL) saveData
{
	NSString * path = [NSString stringWithFormat:@"%@/Documents/MessageDrop_SavedData", NSHomeDirectory()]; 

	NSMutableData *data;
	NSKeyedArchiver *archiver;
	
	data = [NSMutableData data];
	archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject: messageBank forKey:@"messageBank"];
	
	[archiver finishEncoding];
	[archiver release];
	
	[data writeToFile:path atomically:YES];
	
	return TRUE;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Username and Password geters and setters

- (NSString*) userName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERNAME];
}

- (void) setUserName: (NSString*) newUserName
{
	[[NSUserDefaults standardUserDefaults] setObject:newUserName forKey:DEFAULTS_USERNAME];
}

- (NSString*) password
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_PASSWORD];
}

- (void) setPassword: (NSString*) newPassword
{
	[[NSUserDefaults standardUserDefaults] setObject:newPassword forKey:DEFAULTS_PASSWORD];
}

- (void) createNewUserDidFinish: (id) sender
{		
	[sender release];
	[window addSubview:mainView];
}

- (void) createNewUserDidCancel: (id) sender
{
	[sender release];
	[window addSubview:mainView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN TABLE VIEW ACTIONS

- (IBAction)checkMessages:(id)sender
{
	[self checkMessages];
}

- (IBAction)deleteMessage:(id)sender
{
	NSIndexPath * path = [messageTableView indexPathForSelectedRow];
	if (path == nil) return;
	int row = [path row];
	NSLog(@"Deleting Row %d", row);
	[messageBank deleteMessageAtIndex: row];
	[messageTableView reloadData];
}


- (IBAction)newMessage:(id)sender
{
	[self createNewMessage];
}

- (IBAction)replyToMessage:(id)sender
{
	
	NSIndexPath * path = [messageTableView indexPathForSelectedRow];
	if (path == nil) return;
	int row = [path row];
	NSLog(@"Replying to message at row: %d", row);
	CreateNewMessage * createNewMesssage = [[CreateNewMessage alloc] initForWindow:window appDelegate:self];
	[mainView removeFromSuperview];
	[createNewMesssage goReply:[[messageBank messageAtIndex:row] sender]];	
}

// used by ViewMessage to reply to a message being viewed
- (void) replyToSender: (NSString*) sender
{
	CreateNewMessage * createNewMesssage = [[CreateNewMessage alloc] initForWindow:window appDelegate:self];
	[mainView removeFromSuperview];
	[createNewMesssage goReply:sender];		
	
}

- (IBAction)setup:(id)sender
{
	[self openPreferences];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CREATE NEW MESSAGE METHODS

- (void) createNewMessage
{
	CreateNewMessage * createNewMesssage = [[CreateNewMessage alloc] initForWindow:window appDelegate:self];
	[mainView removeFromSuperview];
	[createNewMesssage go];
}

- (void) createNewMessageFinishedWithMessage: (Message*) newMessage sender: (id) sender
{
	[newMessage retain];
	//[newMessage pushToLog];
	[sender release];
	[self getLocationForMessage:newMessage];
}

- (void) createNewMesssageCanceled: (id) sender
{
	[window addSubview:mainView];
	[sender release];	
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// GetLocationForMessage - used when creating a new message to give it a location stamp

- (void) getLocationForMessage: (Message*) message
{
	//[message pushToLog];
	GetLocationForMessage * glfm = [[GetLocationForMessage alloc] initForWindow:window appDelegate:self];
	[glfm getLocationForMessage:message];
}

- (void) locationFoundForMessage:(Message*) message sender: (id) sender
{
	[sender release];
	[message setSender:[self userName]];
	[self sendMessage:message];
	[window addSubview:mainView];
}

- (void) locationCanceledForMessage:(Message*) message sender: (id) sender
{
	[message release];
	[sender release];
	[window addSubview:mainView];	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SEND MESSAGE METHODS

- (void) sendMessage: (id) message
{
	NSLog(@"Sending message...");
	[SendMessages sendMessage:message];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CHECK MESSAGES METHODS

- (void) checkMessages
{
	if ([[NSBundle mainBundle] loadNibNamed:@"CheckingMessages" owner:self options:nil] == nil)
	{
		NSLog(@"Error! Could not load CheckingMessages NIB file.\n");
	}
	
	[checkingMessagesView retain];
	
	[mainView removeFromSuperview];
	[window addSubview: checkingMessagesView];
	[checkingMessagesActivityIndicator startAnimating];
	
	CheckMessages * checkMessages = [[CheckMessages alloc] initForAppDelegate:self];
	[checkMessages sendRequestForMessagesToServerForUser: [self userName] password: [self password]];
}

// CheckMessages delegate method - called when the parser has returned an array of new messages
- (void) messagesReceived: (NSArray*) receivedMessages sender: (id) sender
{
	if ([receivedMessages count] == 0)
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sorry, nobody loves you.  Awww." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Congratulations! %d messages received!",[receivedMessages count]] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
	
	[messageBank addMessages:receivedMessages];
	[messageTableView reloadData];

	[checkingMessagesView removeFromSuperview];
	[window addSubview:mainView];
	
	[sender release];
	[checkingMessagesView release];
	
	[self getCurrentLocationAndUnlockMessages];
}

// CheckMessages delegate method - called to report an error making connection, receiving messages, or parsing response
- (void) checkMessagesError: (NSString*) error sender: (id) sender
{
	NSLog(@"Error: %@", error);
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error checking messages!" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];		

	[checkingMessagesView removeFromSuperview];
	[window addSubview:mainView];
	
	[sender release];
	[checkingMessagesView release];
}


// CheckMessages delegate method - called to report that the request for messages has been sent to the server
- (void) checkMessagesRequestSent
{
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// GetLocation methods - used when checking messages to find current location and unlock messages

- (void) getCurrentLocationAndUnlockMessages
{
	[mainView removeFromSuperview];
	[[[GetLocation alloc] initForWindow:window appDelegate:self] getLocation];  // this starts the process of reading the location, when either found or canceled, delegate
	// routines below are called
}

// Called by the GetLocation object when the location is found and accepted by user
- (void) locationFound: (CLLocation*) location sender: (id) sender
{
	[location retain];
	[sender release];
	int numUnlocked = [messageBank unlockMessagesForLocation:location];
	
	NSString * alertMessage;
	
	if (numUnlocked == 0)
	{
		alertMessage = @"Sorry!  You did not unlock any messages.";
	}
	else if (numUnlocked == 1)
	{
		alertMessage = @"Hey! You unlocked 1 message!";
	}
	else
	{
		alertMessage = [NSString stringWithFormat:@"Hey! You unlocked %d messages!", numUnlocked];
	}
	
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle: alertMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];		
	
	[location release];
	[window addSubview:mainView];
	[messageTableView reloadData];
}

// Called by the GetLocation object when the location is canceled by user
- (void) locationCanceledSender: (id) sender
{
	[sender release];
	[window addSubview:mainView];
	[messageTableView reloadData];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREFERENCES

- (void) openPreferences
{
	EditPreferences * ep = [[EditPreferences alloc] initForWindow:window appDelegate:self];
	[mainView removeFromSuperview];
	[ep go];
}

- (void) editPreferencesFinished: (id) sender
{
	[sender release];
	[window addSubview:mainView];
}

@end

