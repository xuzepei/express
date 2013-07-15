//
//  Food.h
//  Food
//
//  Created by xuzepei on 9/28/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Food :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * isHidden;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isFavorited;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;

@end



