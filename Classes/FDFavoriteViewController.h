//
//  FDFavoriteViewController.h
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"

@interface FDFavoriteViewController : UIViewController 
<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
	UITableView* _tableView;
	NSMutableArray* _itemArray;
	BOOL _cellEditing;
}

@property(nonatomic,retain)UITableView* _tableView;
@property(nonatomic,retain)NSMutableArray* _itemArray;
@property(nonatomic,retain)Record* selectedRecord;
@property(nonatomic,retain)MBProgressHUD* _indicator;

- (void)initTableView;
- (void)updateContent:(NSNotification*)notification;
- (void)updateBadge;

@end
