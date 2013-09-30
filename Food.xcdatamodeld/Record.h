//
//  Record.h
//  Food
//
//  Created by xuzepei on 12/19/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Record :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSNumber * isHidden;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * note;

@end



