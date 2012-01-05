//
//  CheckMessages.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CheckMessages : NSObject 
{
	NSMutableArray * receivedMessages;
	id appDelegate;
}
- (id) initForAppDelegate: (id) _appDelegate;

- (void) sendRequestForMessagesToServerForUser: (NSString*) user password: (NSString*) password;

// NSURLCONNECT DELEGATE METHODS
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
