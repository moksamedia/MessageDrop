//
//  ViewMessage.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface ViewMessage : NSObject 
{
	UIWindow * window;
	id appDelegate;
	
	BOOL locked;
	BOOL hidden;
	
	UIView *contentView;
	UIView *topView;
	IBOutlet UIScrollView * scrollView;
	IBOutlet UILabel *fromLabel;
	IBOutlet UILabel *hintLabel;
	IBOutlet UILabel *lockedLabel;
	IBOutlet UILabel *messageLabel;
	IBOutlet UITextView *hintTextView;
	IBOutlet UITextView *messageTextView;
	IBOutlet UIWebView *webView;
	
	Message * message;
}

@property IBOutlet UIView *contentView;
@property IBOutlet UIView *topView;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate message: (Message*) _message;

- (IBAction)back:(id)sender;
- (IBAction)reply:(id)sender;

void MoveUp(int offsetY, UIView * view);

@end
