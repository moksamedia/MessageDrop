//
//  FileUpload.m
//  Message Drop
//
//  Created by Andrew Hughes on 12/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FileUpload.h"

- (id) initWithMessageText: (NSString*) _messageText 
hint: (NSString*) _hint 
receiver: (NSString*) _receiver 
sender: (NSString*) _sender 
hasBeenRead: (BOOL) _hasBeenRead 
hidden: (BOOL) _hidden 
location: (CLLocation *) _location 
hitToleranceInSeconds: (float) tolerance;


@implementation FileUpload

- (BOOL)sendMessage:(id)message 
{
	
	NSString * messageText = [message messageText];
	NSString * receiver = [message receiver];
	NSString * sender = [message sender];
	BOOL hasBeenRead = [message hasBeenRead];
	BOOL hidden = [message hidden];
	CLLocation * location = [message location];
	float hitToleranceInSeconds = [message hitToleranceInSeconds];
	
	//creating the url request:
	NSURL *cgiUrl = [NSURL URLWithString:@"http://127.0.0.1/sendmessage.php"];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
	
	//HEADER
	[postRequest setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=123456789BoUnDrY987654321"];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	
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
	// hitToleranceInSeconds
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"hitToleranceInSeconds\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%f", hitToleranceInSeconds] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"test.txt\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[NSData dataWithContentsOfFile:@"/test.txt"]];
	*/
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
	
	//sending the request via the 'htmlView' WebView:
	[[htmlView mainFrame] loadRequest:postRequest];
}
@end
