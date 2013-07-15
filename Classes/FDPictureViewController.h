//
//  FDPictureViewController.h
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "ZBarSDK.h"

@class Express;
@interface FDPictureViewController : UIViewController
<UIScrollViewDelegate,UITextFieldDelegate,OHAttributedLabelDelegate,UIAlertViewDelegate,ZBarReaderDelegate> {

	UIScrollView* _scrollView;
	UITextField* _inputTF;
	UIButton* _selectExpressButton;
	UIButton* _inquiryButton;
	Express* _selectedExpress;
	
	MBProgressHUD* _indicator;
	
	NSString* _phoneNum;
	NSString* _web;
	
	UILabel* _label2;
	UILabel* _label3;
	OHAttributedLabel* _phoneNumLabel;
	OHAttributedLabel* _webLabel;
}

@property(nonatomic,retain)UIScrollView* _scrollView;
@property(nonatomic,retain)UITextField* _inputTF;
@property(nonatomic,retain)UIButton* _selectExpressButton;
@property(nonatomic,retain)UIButton* _inquiryButton;
@property(nonatomic,retain)UIButton* _scanButton;
@property(nonatomic,retain)Express* _selectedExpress;
@property(nonatomic,retain)MBProgressHUD* _indicator;
@property(nonatomic,retain)NSString* _phoneNum;
@property(nonatomic,retain)NSString* _web;

@property(nonatomic,retain)UILabel* _label2;
@property(nonatomic,retain)UILabel* _label3;
@property(nonatomic,retain)OHAttributedLabel* _phoneNumLabel;
@property(nonatomic,retain)OHAttributedLabel* _webLabel;

@property(nonatomic,assign)BOOL updateTitle;

- (void)initScrollView;
- (void)updateSelectedExpress:(Express*)express;

@end
