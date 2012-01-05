//
//  Message_DropAppDelegate.h
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBank.h"
#import "CheckMessages.h"
#import "LocationController.h"
#import "Message.h"

@interface Message_DropAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIWindow *window;
	IBOutlet UITableView *messageTableView;
	UIView * mainView;

	LocationController * locationController;
	
	NSString * userName;
	NSString * password;
	
	//IBOutlet id secondViewController;  // create new message view
	//IBOutlet id firstViewController;  // table view that shows list of messages
	
	IBOutlet UIView * checkingMessagesView;
	IBOutlet UIActivityIndicatorView * checkingMessagesActivityIndicator;
	
	//CheckMessages * checkMessages;	// object that queries the server for new messages and parses the XML response
	
	MessageBank * messageBank;  // main data structure, holds the messages
		
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *mainView;
@property (retain) MessageBank * messageBank;

// get / set username and password to preferences
- (NSString*) userName;
- (void) setUserName: (NSString*) newUserName;
- (NSString*) password;
- (void) setPassword: (NSString*) newPassword;

// send messages
- (void) sendMessage: (id) message;

// check messages
- (void) checkMessages;
	// delegate methods for CreateNewMessage
- (void) checkMessagesRequestSent;
- (void) checkMessagesError: (NSString*) error sender: (id) sender;
- (void) messagesReceived: (NSArray*) receivedMessages sender: (id) sender;
- (IBAction) cancelCheckMessages: (id) sender;

// preferences
- (void) openPreferences;
	// delegate methods for EditPreferences
- (void) editPreferencesFinished: (id) sender;

// action methods for when program is first run, to create user account
- (void) createNewUserDidFinish: (id) sender;
- (void) createNewUserDidCancel: (id) sender;

//- (BOOL) getUserNameFromPreferences;

// save and load data methods
- (BOOL) openSavedData;
- (BOOL) saveData;

// message table view (main view) action messages
- (IBAction)checkMessages:(id)sender;
- (IBAction)deleteMessage:(id)sender;
- (IBAction)newMessage:(id)sender;
- (IBAction)replyToMessage:(id)sender;
- (void) replyToSender: (NSString*) sender;

- (IBAction)setup:(id)sender;

// create new message methods
- (void) createNewMessage;
	// delegate methods for CreateNewMessage
- (void) createNewMessageFinishedWithMessage: (Message*) newMessage sender: (id) sender;
- (void) createNewMesssageCanceled: (id) sender;

// GetLocationForMessage methods
- (void) getLocationForMessage: (Message*) message;
- (void) locationFoundForMessage:(Message*) message sender: (id) sender;
- (void) locationCanceledForMessage:(Message*) message sender: (id) sender;

// GetLocation methods
- (void) getCurrentLocationAndUnlockMessages;
- (void) locationFound: (CLLocation*) location sender: (id) sender;
- (void) locationCanceledSender: (id) sender;

// TableView DataSource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
- (void) viewMessageFinish: (id) sender;



@end
