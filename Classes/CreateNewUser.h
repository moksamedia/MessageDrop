//
//  CreateNewUser.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IsUserNameTaken.h"
#import "CreateNewAccount.h"

@interface CreateNewUser : NSObject <UITextFieldDelegate>
{
	UIWindow * window;
	id appDelegate;
	
	IsUserNameTaken * isUserNameTaken;	// handles the communication with the internet server to query if username is already taken
	CreateNewAccount * createNewAccount;
	
	int state;
	
	UIView *chooseUserNameView;  // this is the first view, where the user chooses a user name and the prog. checks the server to see if it has been taken
	IBOutlet UILabel *chooseUserNameLabel;
	IBOutlet UITextField *provisionalUserName;

	UIView *choosePasswordAndFinishView;  // the seconds view, where the user has successfully chosen a username, and chooses a password and provides an email address
	IBOutlet UITextField *choosePasswordTextField;
	IBOutlet UITextField *confirmPasswordTextField;
	IBOutlet UITextField *emailAddressTextField;
	IBOutlet UITextField *yourNewUserNameIsTextField;
	IBOutlet UITextField *choosePasswordAndFinishUserNameTextView;
	IBOutlet UIActivityIndicatorView * activityIndicator;
	
	UIView *connectingToServerView;
	
	NSString * userName;
	NSString * password;
	NSString * emailAddress;
	
}

// Top level NIB objects (retained, must be released)
@property (retain) IBOutlet UIView *chooseUserNameView;
@property (retain) IBOutlet UIView *choosePasswordAndFinishView;
@property (retain) IBOutlet UIView *connectingToServerView;
@property (retain) NSString * userName;
@property (retain) NSString * password;
@property (retain) NSString * emailAddress;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate;
- (void) go;


//- (IBAction)chooseUserNameCancel: (id) sender;
- (IBAction)chooseUserNameOK: (id) sender;

//- (IBAction)choosePasswordAndFinishCancel: (id) sender;
- (IBAction)choosePasswordAndFinishOK: (id) sender;

- (IBAction) cancel: (id) sender;

- (void) userNameTaken;
- (void) userNameNotTaken;
- (void) isUserNameTakenRequestSent;
- (void) isUserNameTakenError: (NSString*) errorString;
+ (BOOL) validateProposedUserName: (NSString*) user;
- (IBAction) connectingToServerCancel: (id) sender;
+ (BOOL) validatePassword: (NSString*) passwd;
- (void) createNewUserRequestSent;
- (void) createNewUserError: (NSString*) errorString;
- (void) createNewUserSuccess;

@end
