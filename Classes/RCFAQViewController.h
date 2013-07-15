//
//  RCFAQViewController.h
//  Emoji2
//
//  Created by zepei xu on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCFAQViewController : UITableViewController

@property(nonatomic,retain)NSMutableArray* _itemArray;

- (void)updateContent;

@end
