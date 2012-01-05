//
//  SecondViewController.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController
{
	
	IBOutlet id appDelegate;

	// CREATE MESSAGE TEXT VIEW
	IBOutlet UIView * secondView;
	IBOutlet UITextView * messageTextView;
	IBOutlet UITextField * toTextField;
	IBOutlet UIScrollView * scrollView;
	
}
- (IBAction) dropNewMessage: (id) sender;

@end
