//
//  FirstViewController.h
//  Message Drop
//
//  Created by Andrew Hughes on 12/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController 
{
	IBOutlet id appDelegate;

	// TABLE VIEW MESSAGE VIEW
	IBOutlet UITableView * tableView;
	IBOutlet UIView * firstView;
	
	id dataSource;
}

- (IBAction) openPreferences: (id) sender;
- (IBAction) deleteMessage: (id) sender;
- (IBAction) replyMessage: (id) sender;
- (IBAction) showMessage: (id) sender;
- (IBAction) createNewMessage: (id) sender;
- (IBAction) checkMessages: (id) sender;
- (void) setTableViewDataSource: (id) newDataSource;
- (void) reloadData;


@end
