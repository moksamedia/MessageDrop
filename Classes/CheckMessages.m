//
//  CheckMessages.m
//  Message Drop
//
//  Created by Andrew Hughes on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CheckMessages.h"
#import "Network.h"
#import "IncomingMessageParser.h"
#import "Message_DropAppDelegate.h"
#import "Definitions.h"

@implementation CheckMessages

- (id) initForAppDelegate: (id) _appDelegate
{
	if ((self = [super init]))
	{
		appDelegate = _appDelegate;
	}
	return self;
}

- (void) sendRequestForMessagesToServerForUser: (NSString*) user password: (NSString*) password
{
	// String containing the url-encoded params, in this case the user name
	NSString *post = [NSString stringWithFormat: @"user=%@&password=%@", [Network urlEncodeValue:user], [Network urlEncodeValue:password]];
	
	// Get an NSData from the string
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// the length of the data, for the header
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	// Create the request object
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	// Set the request params
	[request setURL:[NSURL URLWithString:DOWNLOAD_URL]];  // the URL to send the request to
	[request setHTTPMethod:@"POST"];	// the HTTP Method - POST
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  // the length of the data
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];
	
	// Create the connection
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    if (theConnection) 
	{
		[(Message_DropAppDelegate*)appDelegate checkMessagesRequestSent];
    } 
	else 
	{
		[(Message_DropAppDelegate*)appDelegate checkMessagesError:@"Unable to make connection!" sender:self];
	}

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

	NSString * string = [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
	//NSLog(@"DID RECEIVE DATA: %@ - %@", [data description], string);
	NSLog(@"DID RECEIVE DATA:\n%@",string);

	[data writeToFile:@"/Users/andrewhughes/Desktop/test.html" atomically:NO];
	
	IncomingMessageParser * parser = [[IncomingMessageParser alloc] init];
	
	if ([string length] > 6 && [[string substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"ERROR:"])
	{
		[(Message_DropAppDelegate*)appDelegate checkMessagesError: [string substringWithRange:NSMakeRange(6, [string length] - 6)] sender: self];		
	}
	else if ([parser parseXMLData:data])
	{
		[(Message_DropAppDelegate*)appDelegate messagesReceived: [parser parsedMessages] sender: self];
	}
	else
	{
		[(Message_DropAppDelegate*)appDelegate checkMessagesError:[NSString stringWithFormat:@"Error parsing server response:%@", string] sender: self];
	}
	
	[connection release];
	[string release];
	[parser release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
 	
    // inform the user
    //NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	[(Message_DropAppDelegate*)appDelegate checkMessagesError:[NSString stringWithFormat:@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]] sender: self];	
}

@end
