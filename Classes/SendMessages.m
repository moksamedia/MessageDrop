//
//  SendMessages.m
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

#import "SendMessages.h"
#import "Definitions.h"

@implementation SendMessages

+ (int) sendMessage: (Message *) messageToSend
{
	[messageToSend retain];
	[messageToSend pushToLog];

	NSMutableURLRequest *request = [[self makePostRequestForMessage: messageToSend] retain];
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:[SendMessages class]];
	
	[request release];
	
	if (theConnection) 
	{
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
	} else 
	{
		// inform the user that the download could not be made
	}
	[messageToSend release];
}
/*
	TODO - implement this as a delegate with callbacks to report send message errors
 */
+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

	NSString * string = [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
	NSLog(@"DID RECEIVE DATA: %@ - %@", [data description], string);
	
	[data writeToFile:@"/Users/andrewhughes/Desktop/test.html" atomically:NO];
	// append the new data to the receivedData
	// receivedData is declared as a method instance elsewhere
	//[receivedData appendData:data];
	
	if ([string length] > 6 && [[string substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"ERROR:"])
	{
		//[(Message_DropAppDelegate*)appDelegate sendMessagesError: [string substringWithRange:NSMakeRange(6, [string length] - 6)]];		
	}
	
	[connection release];
	[string release];
}

+ (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
 	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

+ (NSMutableURLRequest *) makePostRequestForMessage: (Message *) message
{
	NSString * messageText = [message messageText];
	NSString * receiver = [message receiver];
	NSString * sender = [message sender];
	NSString * hint = [message hint];
	int hasBeenRead = [message hasBeenRead];
	int hidden = [message hidden];
	int locked = [message locked];
	CLLocation * location = [message location];
	float hitToleranceInMeters = [message hitToleranceInMeters];
	
	//creating the url request:
	NSURL * url = [NSURL URLWithString:SEND_URL];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
	
	//HEADER
	[postRequest setHTTPMethod:@"POST"];
	NSString * stringBoundary = [NSString stringWithString: @"123456789BoUnDrY987654321"];
	[postRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary] forHTTPHeaderField: @"Content-Type"];
	
	
	//BODY
	NSMutableData *postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"messageText\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	// Message Text
	[postBody appendData:[messageText dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// Receiver
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"receiver\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[receiver dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// Sender
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[sender dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// Hint
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"hint\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[hint dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// hasBeenRead
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"hasBeenRead\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%d",hasBeenRead] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// hidden
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"hidden\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%d",hidden] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// lattitude
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lattitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%f",[location coordinate].latitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// longitude
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%f",[location coordinate].longitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// hitToleranceInMeters
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"hitToleranceInMeters\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%f", hitToleranceInMeters] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// locked
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"locked\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%d",locked] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*
	 [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"test.txt\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [postBody appendData:[NSData dataWithContentsOfFile:@"/test.txt"]];
	 */
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
	
	[stringBoundary release];
	//[postRequest autorelease];
	return postRequest;
}


@end
