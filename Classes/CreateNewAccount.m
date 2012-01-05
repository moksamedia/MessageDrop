//
//  CreateNewAccount.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
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

#import "CreateNewAccount.h"
#import "CreateNewUser.h"
#import "Network.h"
#import "Definitions.h"

@implementation CreateNewAccount

- (id) initForAppDelegate: (id) _appDelegate
{
	if ((self = [super init]))
	{
		appDelegate = _appDelegate;
	}
	return self;
}

- (void) createNewAccountForUser: (NSString*) userName password:(NSString*) password email: (NSString*) emailAddress;
{
	// String containing the url-encoded params, in this case the user name
	NSString *post = [NSString stringWithFormat: @"user=%@&password=%@&email=%@", [Network urlEncodeValue:userName], [Network urlEncodeValue:password], [Network urlEncodeValue:emailAddress]];
	
	// Get an NSData from the string
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// the length of the data, for the header
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	// Create the request object
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	// Set the request params
	[request setURL:[NSURL URLWithString:CREATENEWUSER_URL]];  // the URL to send the request to
	[request setHTTPMethod:@"POST"];	// the HTTP Method - POST
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  // the length of the data
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];
	
	// Create the connection
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    if (theConnection) 
	{
		[(CreateNewUser*)appDelegate createNewUserRequestSent];
    } 
	else 
	{
		[(CreateNewUser*)appDelegate createNewUserError:@"Unable to make connection!"];
	}
	
}

// NSURLCONNECT DELEGATE METHODS
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
	NSString * string = [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
	//NSLog(@"DID RECEIVE DATA: %@ - %@", [data description], string);
	NSLog(@"DID RECEIVE DATA:\n%@",string);
	
	if ([string isEqualToString:@"SUCCESS"])
	{
		[(CreateNewUser*)appDelegate createNewUserSuccess];
	}
	else 
	{
		[(CreateNewUser*)appDelegate createNewUserError:[NSString stringWithFormat:@"Connection failed! Error - %@", string]];	
	}
	[string release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
 	
    // inform the user
    //NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	[(CreateNewUser*)appDelegate createNewUserError:[NSString stringWithFormat:@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]]];	
}

@end
