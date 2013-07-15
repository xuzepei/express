//
//  Express.h
//  Food
//
//  Created by xuzepei on 12/20/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Express :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isInquired;
@property (nonatomic, retain) NSNumber * isUsually;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isHidden;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * phoneNum;
@property (nonatomic, retain) NSString * web;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSString * api;
@property (nonatomic, retain) NSString * name;

@end



