//
//  ViewMessage.m
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

#import "ViewMessage.h"
#import "GetLocationForMessage.h"
#import "Message_DropAppDelegate.h"


@implementation ViewMessage

@synthesize contentView;
@synthesize topView;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate message: (Message*) _message
{
	if ((self = [super init]))
	{
		window = _window;
		appDelegate = _appDelegate;
		message = _message;
		
		// LOAD THE NIB
		if ([[NSBundle mainBundle] loadNibNamed:@"ViewMessage" owner:self options:nil] == nil)
		{
			NSLog(@"Error! Could not load ViewMessage NIB file.\n");
		}
		
		[fromLabel setText:[NSString stringWithFormat:@"From: %@", [message sender]]];
		[hintTextView setText:[message hint]];
		
		if ([message locked] == 0) locked = FALSE;
		else locked = TRUE;
		
		if ([message hidden] == 0) hidden = FALSE;
		else hidden = TRUE;
		
		// SET UP VIEW

		[hintTextView setEditable:FALSE];
		[messageTextView setEditable:FALSE];

		// UNLOCKED
		if (!locked)
		{
			// Hide the ----LOCKED----
			[lockedLabel setHidden:TRUE];
			
			// Shift everything up
			MoveUp(41, fromLabel);
			MoveUp(41, hintLabel);
			MoveUp(41, hintTextView);
			MoveUp(41, messageLabel);
			MoveUp(41, messageTextView);
			MoveUp(41, webView);
			
			[hintTextView setText:[message hint]];
			[messageTextView setText:[message messageText]];
			
			// set up the webview
			[webView setScalesPageToFit:FALSE];
			[webView loadRequest: [GetLocationForMessage urlRequestForLocation: [message location]]];
		}
		else if (locked && !hidden)
		{
			[hintTextView setText:[message hint]];
			[messageTextView setHidden:TRUE];
			[messageLabel setHidden:TRUE];
			
			// set up the webview
			[webView setScalesPageToFit:FALSE];
			[webView loadRequest: [GetLocationForMessage urlRequestForLocation:[message location]]];
			
		}
		else if (locked && hidden)
		{
			[hintTextView setText:[message hint]];
			[messageTextView setHidden:TRUE];
			[messageLabel setHidden:TRUE];
			[webView setHidden:TRUE];
		}
		
		
		scrollView.contentSize = CGSizeMake(320, 764);
		[scrollView addSubview:contentView];
		
		[window addSubview:topView];
		
		}
	return self;
}

void MoveUp(int offsetY, UIView * view)
{
	CGPoint oldCenter = [view center];
	oldCenter.y = oldCenter.y - offsetY;
	[view setCenter: oldCenter];
}

- (void) dealloc
{
	[topView release];
	[contentView release];
	[super dealloc];
}

- (IBAction)back:(id)sender
{
	[topView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate viewMessageFinish:self];
}

- (IBAction)reply:(id)sender
{
	[topView removeFromSuperview];
	[(Message_DropAppDelegate*)appDelegate replyToSender:[message sender]];
}


@end
