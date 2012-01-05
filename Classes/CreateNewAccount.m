//
//  CreateNewAccount.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
