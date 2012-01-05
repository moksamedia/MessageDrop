//
//  CreateNewAccount.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreateNewAccount : NSObject 
{
	id appDelegate;
}
- (id) initForAppDelegate: (id) _appDelegate;

- (void) createNewAccountForUser: (NSString*) userName password:(NSString*) password email: (NSString*) emailAddress;

// NSURLCONNECT DELEGATE METHODS
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
