//
//  RCHttpRequest.h
//  rsscoffee
//
//  Created by xuzepei on 09-9-8.
//  Copyright 2009 Rumtel Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCHttpRequestDelegate <NSObject>
@optional
- (void) willStartHttpRequest;
- (void) willStartHttpRequest: (NSString*)urlString token:(id)token;
- (void) didFinishHttpRequest;
- (void) didFinishHttpRequest: (NSString*)urlString result:(id)result token:(id)token;
- (void) didFailHttpRequest;
- (void) didFailHttpRequest: (NSString*)urlString token:(id)token;

- (void) willStartHttpRequest: (id)token;
- (void) didFinishHttpRequest: (id)result;
- (void) didFinishHttpRequest: (id)result token: (id)token;
- (void) didFailHttpRequest: (id)token;
- (void) updatePercentage: (float)percentage token: (id)token;
- (void) didFinishADHttpRequest:(id)result token:(id)token;
- (void) didFinishSendReview:(id)result token:(id)token;
- (void) didFailSendReview: (id)token;

- (void)didFinishSearchHttpRequest:(id)result token:(id)token;
- (void)didFinishPublicHttpRequest:(id)result token:(id)token;
- (void)didFinishSecondHttpRequest:(id)result token:(id)token;
- (void)didFinishLocalStatusHttpRequest:(id)result token:(id)token;
@end


@interface RCHttpRequest : NSObject {
	
	NSMutableData* _receivedData;
	BOOL _isConnecting;
	id _delegate;
	int _statusCode;
	int _contentType;
	int _requestType;
	NSString* _requestingURL;
	id _token;
	long long _expectedContentLength;
	long long _currentLength;
	NSURLConnection* _urlConnection;

}

@property (nonatomic, retain) NSMutableData* _receivedData;
@property (nonatomic, assign) BOOL _isConnecting; 
@property (nonatomic, assign) id _delegate;
@property (assign) int _statusCode;
@property (assign) int _contentType;
@property (assign) int _requestType;
@property (nonatomic, retain) NSString* _requestingURL;
@property (nonatomic, retain) id _token;
@property (assign) long long _expectedContentLength;
@property (assign) long long _currentLength;
@property (nonatomic, retain) NSURLConnection* _urlConnection;

@end
