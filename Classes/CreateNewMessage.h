//
//  CreateNewMessage.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreateNewMessage : NSObject <UITextViewDelegate, UITextFieldDelegate>
{
	IBOutlet UITextField *toTextField;
	IBOutlet UITextView *hintTextView;
	IBOutlet UITextView *messageTextView;
	IBOutlet UIButton *hideShowButton;
	IBOutlet UIScrollView *scrollView;
	UIView * contentView;
	UIView * topView;
	
	UIWindow * window;
	id appDelegate;
	
	bool hidden;
}

//@property (retain) IBOutlet UIScrollView *scrollView;
@property (retain) IBOutlet UIView *topView;
@property (retain) IBOutlet UIView *contentView;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate;
- (void) go;
- (void) goReply: (NSString*) receiver;

- (IBAction) dropMessage: (id) sender;
- (IBAction) hide_unhideButtonClicked: (id) sender;
- (IBAction) hideKeyboard: (id) sender;
- (IBAction) cancel: (id) sender;
@end
