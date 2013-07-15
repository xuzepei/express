//
//  FDResultViewController.h
//  Food
//
//  Created by xuzepei on 12/19/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface FDResultViewController : UIViewController 
<UITableViewDelegate,UITableViewDataSource> 
{
	UITableView* _tableView;
	NSMutableArray* _itemArray;
}

@property(nonatomic,retain)UITableView* _tableView;
@property(nonatomic,retain)NSMutableArray* _itemArray;
@property(nonatomic,retain)Record* record;
@property(nonatomic,retain)NSDictionary* result;

- (void)initTableView;
- (void)updateContent:(Record*)aRecord;

@end
