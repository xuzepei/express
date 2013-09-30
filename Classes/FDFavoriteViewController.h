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
#import "RCAddNoteView.h"

@interface FDFavoriteViewController : UIViewController 
<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
	BOOL _cellEditing;
}

@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)NSMutableArray* itemArray;
@property(nonatomic,retain)Record* selectedRecord;
@property(nonatomic,retain)MBProgressHUD* indicator;

@property(nonatomic,retain)UIView* maskView;
@property(nonatomic,retain)RCAddNoteView* addNoteView;

- (void)initTableView;
- (void)updateContent:(NSNotification*)notification;
- (void)updateBadge;

@end
