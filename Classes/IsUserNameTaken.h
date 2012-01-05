//
//  IsUserNameTaken.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IsUserNameTaken : NSObject 
{
	id appDelegate;
}
- (id) initForAppDelegate: (id) _appDelegate;

- (void) checkIfUserNameIsTaken: (NSString*) userName;

// NSURLCONNECT DELEGATE METHODS
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
