//
//  FDUnfitViewController.h
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCInfoViewController.h"


@interface FDUnfitViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate> 
{
	
	UITableView* _tableView;
	NSMutableArray* _itemArray;
	NSMutableArray* _searchArray;
	
	UISearchBar* _searchBar;
	UISearchDisplayController* _searchController;
	
@private
	NSFetchedResultsController *fetchedResultsController;
	NSFetchedResultsController *fetchedResultsController2;

}

@property(nonatomic,retain)UITableView* _tableView;
@property(nonatomic,retain)NSMutableArray* _itemArray;
@property(nonatomic,retain)NSMutableArray* _searchArray;

@property(nonatomic,retain)UISearchBar* _searchBar;
@property(nonatomic,retain)UISearchDisplayController* _searchController;

@property(nonatomic, retain)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain)NSFetchedResultsController *fetchedResultsController2;
@property(nonatomic, retain)UIButton* infoButton;

- (void)initTableView;
- (void)updateContent;
- (NSFetchedResultsController *)searchObjects:(NSString*)searchText;

@end
