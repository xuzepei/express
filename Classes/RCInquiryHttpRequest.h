//
//  RCInquiryHttpRequest.h
//  Food
//
//  Created by xuzepei on 12/19/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCHttpRequest.h"

@interface RCInquiryHttpRequest : RCHttpRequest {
	
}

+ (RCInquiryHttpRequest*)sharedInstance;
- (void)request:(NSString*)urlString 
	   delegate:(id)delegate 
		  token:(id)token;

@end
