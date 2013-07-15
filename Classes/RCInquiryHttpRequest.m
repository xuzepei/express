//
//  RCInquiryHttpRequest.m
//  Food
//
//  Created by xuzepei on 12/19/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import "RCInquiryHttpRequest.h"
#import "RCTool.h"

@implementation RCInquiryHttpRequest

+ (RCInquiryHttpRequest*)sharedInstance
{
	static RCInquiryHttpRequest* sharedInstance = nil;
	if(nil == sharedInstance)
	{
		@synchronized([RCInquiryHttpRequest class])
		{
			sharedInstance = [[RCInquiryHttpRequest alloc] init];
		}
	}
	
	return sharedInstance;
}

- (void)request:(NSString*)urlString delegate:(id)delegate token:(id)token
{
	if(0 == [urlString length] || self._isConnecting == YES)
		return;
	
	self._delegate = delegate;
	self._token = token;
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	self._requestingURL = urlString;
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval: TIME_OUT];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"POST"];
	
    if ([token isKindOfClass:[NSDictionary class]])
    {
        NSDictionary * dict = (NSDictionary *)token;
        
        NSMutableArray * params = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSString * key in dict)
        {
            NSString * value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSString class]])
            {
                [params addObject:[NSString stringWithFormat:@"%@=%@",key, value]];
            }
        }
        
        NSString * bodyString = [NSString stringWithFormat:@"%@&muti=1&order=desc&show=0",[params componentsJoinedByString:@"&"]];
        
        NSLog(@"bodyString:%@",bodyString);
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [params release];
    }
	
	
	if([[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES])
	{
		_isConnecting = YES;
		[_receivedData setLength: 0];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

		if([_delegate respondsToSelector: @selector(willStartHttpRequest:)])
			[_delegate willStartHttpRequest:nil];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"request:connectionDidFinishLoading- statusCode:%d",_statusCode);
	
	if(200 == _statusCode)
	{
		NSString* jsonString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
		NSDictionary* dict = [RCTool parse: jsonString];
		//NSLog(@"jsonString:%@",jsonString);
		[jsonString release];
		
		if([_delegate respondsToSelector: @selector(didFinishHttpRequest:token:)])
			[_delegate didFinishHttpRequest:dict token:self._token];
	}
	else
	{
		if([_delegate respondsToSelector: @selector(didFailHttpRequest:)])
			[_delegate didFailHttpRequest:nil];
	}
	
	_isConnecting = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[_receivedData setLength:0];
	[connection release];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSLog(@"request:didFailWithError - statusCode:%d",_statusCode);
	
	if([_delegate respondsToSelector: @selector(didFailHttpRequest:)])
		[_delegate didFailHttpRequest: nil];
	
	_isConnecting = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[_receivedData setLength: 0];
    [connection release];
	
}

@end
