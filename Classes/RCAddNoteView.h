//
//  RCAddNoteView.h
//  Food
//
//  Created by xuzepei on 8/24/13.
//
//

#import <UIKit/UIKit.h>
#import "RCAddNoteView.h"

@protocol RCAddNoteViewDelegate <NSObject>

- (void)clickedCancelButton:(id)token;
- (void)clickedSureButton:(id)token;

@end

@interface RCAddNoteView : UIView

@property(assign)id delegate;
@property(nonatomic,retain)UITextField* inputTF;
@property(nonatomic,retain)UIButton* cancelButton;
@property(nonatomic,retain)UIButton* sureButton;
@property(nonatomic,retain)UILabel* titleLabel;


@end
