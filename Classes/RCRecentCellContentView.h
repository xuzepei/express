//
//  RCRecentCellContentView.h
//  Food
//
//  Created by xuzepei on 8/24/13.
//
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface RCRecentCellContentView : UIView

@property(nonatomic, retain)Record* item;
@property(nonatomic, retain)NSString* imageUrl;
@property(nonatomic, retain)UIImage* image;
@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)BOOL selected;
@property(assign)BOOL isLast;

- (void)updateContent:(id)item;


@end
