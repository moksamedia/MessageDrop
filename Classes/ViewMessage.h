//
//  ViewMessage.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/6/09.
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
