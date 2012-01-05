//
//  SendMessages.h
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
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


@interface SendMessages : NSObject {

}

+ (int) sendMessage: (Message *) aMessage;
+ (NSMutableURLRequest *) makePostRequestForMessage: (Message *) message;

// NSURLCONNECT DELEGATE METHODS
+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
+ (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
