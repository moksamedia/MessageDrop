//
//  SendMessages.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"


@interface SendMessages : NSObject {

}

+ (int) sendMessage: (Message *) aMessage;
+ (NSMutableURLRequest *) makePostRequestForMessage: (Message *) message;

// NSURLCONNECT DELEGATE METHODS
+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
+ (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
