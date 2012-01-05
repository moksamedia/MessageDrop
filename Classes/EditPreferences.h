//
//  EditPreferences.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"
#import "CreateNewUser.h"


@interface EditPreferences : NSObject <UITextFieldDelegate, UIAlertViewDelegate>
{

	UIWindow * window; // passed in by the appDelegate, the main window
	id appDelegate; // the appDelegate itself

	IBOutlet UIScrollView *scrollView;
	UIView * contentView;
	UIView * topView;
	
	//UIView *view;  // the primary preferences view, first to load when -go message is sent
	IBOutlet UITextField * ipAddressTextField;
	IBOutlet UITextField * passwordTextField;
	IBOutlet UITextField * usernameTextField;

	UIView *changeUserView;  // view to change user and password (log in as different user)
	IBOutlet UITextField * changeUserPasswordTextField;
	IBOutlet UITextField * changeUserUsernameTextField;
	
	NSString* userName;
	NSString* password;
	NSString* ipAddress;
	
	CreateNewUser * createNewUser;  // object used to create a new account (handles validation of username and pass as well as communication with server)
}

//@property (retain) IBOutlet UIView * view;
@property (retain) IBOutlet UIView * changeUserView;
@property (retain) IBOutlet UIView * contentView;
@property (retain) IBOutlet UIView * topView;

- (void) go; // called by appDelegate after init to show preferences view
- (IBAction) OK: (id) sender;
- (IBAction) cancel: (id) sender;

- (IBAction) createNewAccount: (id) sender;

- (IBAction) editIPAddress: (id) sender;

- (IBAction) changeUser: (id) sender;
- (IBAction) changeUserOK: (id) sender;
- (IBAction) changeUserCancel: (id) sender;
@end
