//
//  RCRecentCell.h
//  Food
//
//  Created by xuzepei on 8/24/13.
//
//

#import <UIKit/UIKit.h>
#import "RCRecentCellContentView.h"

@interface RCRecentCell : UITableViewCell

@property(nonatomic,retain)RCRecentCellContentView* myContentView;
@property(assign)id delegate;

- (void)updateContent:(id)item height:(CGFloat)height delegate:(id)delegate;

@end
