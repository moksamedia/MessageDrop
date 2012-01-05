//
//  CreateNewMessage.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/5/09.
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

#import "CreateNewMessage.h"
#import "Message_DropAppDelegate.h"
#import "Message.h"
#import "Definitions.h"


float cosineInDegrees(float value);
float convertDegreesLongitudeToMeters(float degreesLongitude, float degreesLattitude);
float convertDegreesLattitudeToMeters(float degreesLattitude);




@implementation CreateNewMessage

//@synthesize scrollView;
@synthesize contentView;
@synthesize topView;

- (id) initForWindow: (UIWindow*) _window appDelegate: (id) _appDelegate
{
	if ((self = [super init]))
	{
		window = _window;
		appDelegate = _appDelegate;
		
		hidden = TRUE;

		// LOAD THE NIB
		if ([[NSBundle mainBundle] loadNibNamed:@"CreateNewMessage" owner:self options:nil] == nil)
		{
			NSLog(@"Error! Could not load CreateNewMessage NIB file.\n");
		}
		
		scrollView.contentSize = CGSizeMake(0, 700);
		[scrollView addSubview:contentView];
		
		[toTextField setDelegate:self];
		[hintTextView setDelegate:self];
		[messageTextView setDelegate:self];
		[hideShowButton setTitle:@"Location is HIDDEN, touch to unhide." forState: UIControlStateNormal];

	}
	return self;
}

- (void) dealloc
{
	[topView release];
	//[contentView release];
	[super dealloc];
}


float convertDegreesLattitudeToMeters(float degreesLattitude)
{	
	float radiusOfEarthInMeters = 6378140.0;
	float pi = 3.14159265358979323846;
	
	float metersPerDegreeLattitude = 2 * pi * radiusOfEarthInMeters / 360.0;
	
	return (float) degreesLattitude * metersPerDegreeLattitude;
}

float convertDegreesLongitudeToMeters(float degreesLongitude, float degreesLattitude)
{	
	
	float metersAtEquator = convertDegreesLattitudeToMeters(1.0);
	float metersAdjustedForLattitude = metersAtEquator * cosineInDegrees(degreesLattitude);
	
	return metersAdjustedForLattitude;
}

float cosineInDegrees(float value)
{
	float pi = 3.14159265358979323846;
	
	float degreesToRadians = pi / 180.0;
	
	float valueRadians = value * degreesToRadians;
	
	return cosf(valueRadians);
}


- (void) go
{
	[window addSubview: topView];
}

- (void) goReply: (NSString*) receiver
{
	[window addSubview: topView];
	[toTextField setText:receiver];
}

- (IBAction)dropMessage: (id) sender
{
	Message * new = [[Message alloc] initWithMessageText: [messageTextView text]
												hint: [hintTextView text]
												receiver: [toTextField text]
												sender: nil
												hasBeenRead: 0 // 0 = FALSE, has not been read
												hidden: hidden 
												location: nil
												hitToleranceInMeters: (float) 100.0
												locked: 1]; // 1 = TRUE, is locked
	[topView removeFromSuperview];
	[appDelegate createNewMessageFinishedWithMessage: new sender:self];
	[new release];
}

- (IBAction) cancel: (id) sender
{
	[topView removeFromSuperview];
	[appDelegate createNewMesssageCanceled: self];
}


- (IBAction)hide_unhideButtonClicked: (id) sender
{
	if (hidden)
	{
		hidden = FALSE;
		[hideShowButton setTitle:@"Location is VISIBLE, touch to hide." forState: UIControlStateNormal];
	}
	else
	{
		hidden = TRUE;
		[hideShowButton setTitle:@"Location is HIDDEN, touch to unhide." forState: UIControlStateNormal];
		
	}
}

- (IBAction) hideKeyboard: (id) sender
{
	[messageTextView resignFirstResponder];
	[hintTextView resignFirstResponder];
	[toTextField resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UITextField Delegate Routines

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
	[textField resignFirstResponder];  // this makes the keyboard go away when the user hits return
	return TRUE;
}

// moves the text views up when the keyboard appears
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	int offset = 0;
	if (textView == hintTextView)
	{
		offset = 83;
	}
	else if (textView == messageTextView)
	{
		offset = 196;		
	}
	
	CGPoint pt ;
	CGRect textViewBounds = [textView bounds];
	CGRect convertedBounds = [textView convertRect:textViewBounds toView:scrollView];
	pt = convertedBounds.origin ;
	pt.x = 0 ;
	pt.y = offset;
	[scrollView setContentOffset:pt animated:YES];	
}
	


@end
