//
//  FDPictureViewController.m
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import "FDPictureViewController.h"
#import "RCTool.h"
#import "MyView.h"
#import "Express.h"
#import "FDSelectExpressViewController.h"
#import "RCInquiryHttpRequest.h"
#import "FDResultViewController.h"
#import "Record.h"
#import <QuartzCore/QuartzCore.h>

#define LINK_COLOR [UIColor blueColor]

#define CONTENT_FONT [UIFont systemFontOfSize:16]
#define LINK_FONT [UIFont systemFontOfSize:19]

@implementation FDPictureViewController
@synthesize _scrollView;
@synthesize _inputTF;
@synthesize _selectExpressButton;
@synthesize _inquiryButton;
@synthesize _scanButton;
@synthesize _selectedExpress;
@synthesize _indicator;
@synthesize _phoneNum;
@synthesize _web;
@synthesize _label2;
@synthesize _label3;
@synthesize _phoneNumLabel;
@synthesize _webLabel;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@""
														   image:[UIImage imageNamed:@"inquiry.png"]
															 tag: TT_PICTURE];
		self.tabBarItem = item;
		[item release];
		
		self.title = NSLocalizedString(@"快递查询",@"");
		self.view.backgroundColor = [UIColor whiteColor];
		
		
		_indicator = [[MBProgressHUD alloc] initWithWindow:[RCTool frontWindow]];
		_indicator.labelText = @"正在查询...";
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification 
												   object:nil];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	
    UIView* adView = [RCTool getAdView];
	if(adView)
	{
		CGRect rect = adView.frame;
        rect.origin.y = self.view.frame.size.height - adView.frame.size.height;
		adView.frame = rect;
		
		[self.view addSubview:adView];
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	MyView* temp = (MyView*)self.view;
	temp._delegate = self;
    
    self.view.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
    
    [self initScrollView];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
//    self._scrollView = nil;
//    self._inputTF = nil;
//    self._selectExpressButton = nil;
//    self._inquiryButton = nil;
//    self._scanButton = nil;
//    
//    self._label2 = nil;
//	self._label3 = nil;
//	self._phoneNumLabel = nil;
//	self._webLabel = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
//    self._scrollView = nil;
//    self._inputTF = nil;
//    self._selectExpressButton = nil;
//    self._inquiryButton = nil;
//    self._scanButton = nil;
//    
//    self._label2 = nil;
//	self._label3 = nil;
//	self._phoneNumLabel = nil;
//	self._webLabel = nil;
}


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self._scrollView = nil;
    self._inputTF = nil;
    self._selectExpressButton = nil;
    self._inquiryButton = nil;
    self._scanButton = nil;
    
    self._label2 = nil;
	self._label3 = nil;
	self._phoneNumLabel = nil;
	self._webLabel = nil;

	[_selectedExpress release];
	[_indicator release];
	[_phoneNum release];
	[_web release];
	
    [super dealloc];
}

- (void)updateSelectedExpress:(Express*)express
{
	self._selectedExpress = express;

	if(_selectedExpress)
	{
        if(self.updateTitle)
            self.navigationItem.title = [NSString stringWithFormat:@"%@查询",_selectedExpress.name];
        
		[_selectExpressButton setTitle:_selectedExpress.name 
							  forState:UIControlStateNormal];
		
//		if([_selectedExpress.num length])
//			_inputTF.text = _selectedExpress.num;
//		else
//			_inputTF.text = @"";
		
		if(_label2)
		{
			[_label2 removeFromSuperview];
			[_label2 release];
			_label2 = nil;
		}
		
		if(_label3)
		{
			[_label3 removeFromSuperview];
			[_label3 release];
			_label3 = nil;
		}
		
		if(_phoneNumLabel)
		{
			[_phoneNumLabel removeFromSuperview];
			[_phoneNumLabel release];
			_phoneNumLabel = nil;
		}
		
		if(_webLabel)
		{
			[_webLabel removeFromSuperview];
			[_webLabel release];
			_webLabel = nil;
		}
		
		_phoneNumLabel = nil;
		if([_selectedExpress.phoneNum length])
		{
			self._label2 = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
			_label2.text = @"电话:";
			_label2.textColor = [UIColor blackColor];
			_label2.backgroundColor = [UIColor clearColor];
			[self.view addSubview: _label2];	

			self._phoneNumLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectZero] autorelease];
            self._phoneNumLabel.underlineLinks = YES;
			_phoneNumLabel.lineBreakMode =
            UILineBreakModeWordWrap;
			_phoneNumLabel.backgroundColor = [UIColor clearColor];
			_phoneNumLabel.delegate = self;
			NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:_selectedExpress.phoneNum];
			[attrStr setFont:CONTENT_FONT];
			_phoneNumLabel.attributedText = attrStr;
			[_phoneNumLabel addCustomLink:[NSURL URLWithString:_selectedExpress.phoneNum] inRange:NSMakeRange(0, [_selectedExpress.phoneNum length])];
			_phoneNumLabel.tag = 110;
			[self.view addSubview: _phoneNumLabel];	
			
			CGFloat offset_y = 20.0;
			if(NO == [RCTool isIpad])
			{
				_label2.frame = CGRectMake(10,offset_y + 120,100,40);
				_label2.font = [UIFont boldSystemFontOfSize:19];
				
				_phoneNumLabel.frame =CGRectMake(62,offset_y + 130,200,40);
			}
			else 
			{
				_label2.frame = CGRectMake(20,offset_y + 270,400,60);
				_label2.font = [UIFont boldSystemFontOfSize:30];
				
				_phoneNumLabel.frame =CGRectMake(120,offset_y + 282,600,60);
			}

		}
		
		
		if([_selectedExpress.web length])
		{
			self._label3 = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
			_label3.text = @"网站:";
			_label3.textColor = [UIColor blackColor];
			_label3.backgroundColor = [UIColor clearColor];
			[self.view addSubview: _label3];	
			
			self._webLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectZero] autorelease];
            self._webLabel.underlineLinks = YES;
			_webLabel.lineBreakMode = UILineBreakModeWordWrap;
			_webLabel.backgroundColor = [UIColor clearColor];
			_webLabel.delegate = self;
			NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:_selectedExpress.web];
			[attrStr setFont:CONTENT_FONT];
			_webLabel.attributedText = attrStr;
            [attrStr setTextAlignment:kCTLeftTextAlignment lineBreakMode:kCTLineBreakByWordWrapping];
            _webLabel.attributedText = attrStr;
			[_webLabel addCustomLink:[NSURL URLWithString:_selectedExpress.web] inRange:NSMakeRange(0, [_selectedExpress.web length])];
			_webLabel.tag = 111;
			[self.view addSubview: _webLabel];	
			
			CGFloat offset_y = 20.0;
			if(NO == [RCTool isIpad])
			{
				_label3.frame = CGRectMake(10,offset_y + 166,100,40);
				_label3.font = [UIFont boldSystemFontOfSize:19];
				
				_webLabel.frame =CGRectMake(62,offset_y + 173,300,60);
			}
			else 
			{
				_label3.frame = CGRectMake(20,offset_y + 380,400,60);
				_label3.font = [UIFont boldSystemFontOfSize:30];
				
				_webLabel.frame =CGRectMake(120,offset_y + 394,600,60);
			}
			
		}
	}
}

- (void)initScrollView
{
	UILabel* label0 = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label0.text = @"快递:";
	label0.textColor = [UIColor blackColor];
	label0.backgroundColor = [UIColor clearColor];
	[self.view addSubview: label0];
	
	UILabel* label1 = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label1.text = @"单号:";
	label1.textColor = [UIColor blackColor];
	label1.backgroundColor = [UIColor clearColor];
	[self.view addSubview: label1];
	
	self._selectExpressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if([RCTool systemVersion] >= 7.0)
    {
        self._selectExpressButton.layer.borderWidth = 1.0f;
        self._selectExpressButton.layer.borderColor = [[UIColor grayColor] CGColor];
        self._selectExpressButton.layer.cornerRadius = 8;
    }
	[_selectExpressButton setTitle:@"请选择快递公司"
						  forState:UIControlStateNormal];
	_selectExpressButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
	[_selectExpressButton addTarget:self action:@selector(clickSelectExpressButton:) 
				   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: _selectExpressButton];
	
	self._inputTF = [[[UITextField alloc] initWithFrame: CGRectZero] autorelease];
	_inputTF.borderStyle = UITextBorderStyleNone;
	_inputTF.placeholder = @"请输入快递单号";
    _inputTF.layer.borderWidth = 1.0f;
    _inputTF.layer.borderColor = [[UIColor grayColor] CGColor];
	_inputTF.delegate = self;
	_inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	_inputTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_inputTF.adjustsFontSizeToFitWidth = NO;
	_inputTF.autocorrectionType = UITextAutocorrectionTypeNo;
	_inputTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_inputTF.returnKeyType = UIReturnKeyDone;
    _inputTF.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
	[self.view addSubview: _inputTF];
    
    self._scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanButton setImage:[UIImage imageNamed:@"scan_button.png"] forState:UIControlStateNormal];
	[_scanButton addTarget:self action:@selector(clickedScanButton:)
				   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: _scanButton];
	
	self._inquiryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if([RCTool systemVersion] >= 7.0)
    {
    self._inquiryButton.layer.borderWidth = 1.0f;
    self._inquiryButton.layer.cornerRadius = 10;
    self._inquiryButton.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    
	[_inquiryButton setTitle:@"开始查询"
						  forState:UIControlStateNormal];
	
	[_inquiryButton addTarget:self action:@selector(clickInquiryButton:) 
				   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: _inquiryButton];
	
	NSString* id = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_select"];
	if([id length])
	{
		NSString* idString = id;
		NSManagedObjectContext* insertionContext = [RCTool getManagedObjectContext];
		NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isHidden = NO && id = %@",idString];
		NSManagedObjectID* objectID = [RCTool getExistingEntityObjectIDForName: @"Express"
																	 predicate: predicate
															   sortDescriptors: nil
																	   context: insertionContext];
		Express* express = nil;
		if(objectID)
		{
			express = (Express*)[RCTool insertEntityObjectForID:objectID
										   managedObjectContext:insertionContext];
			
			[self updateSelectedExpress:express];
		}
	}

	
	CGFloat offset_y = 20.0;
	if(NO == [RCTool isIpad])
	{
		_selectExpressButton.frame = CGRectMake(60,offset_y,200,40);
		_selectExpressButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
		_inputTF.frame = CGRectMake(60, offset_y + 60, 200, 40);
		_inputTF.font = [UIFont systemFontOfSize: 20];
        
        _scanButton.frame = CGRectMake(320 - 40 - 10, offset_y + 60, 40, 40);
        
        CGFloat inquiryButtonOriginY = self.view.frame.size.height - 50.0 - 30.0;
		_inquiryButton.frame = CGRectMake(([RCTool getScreenSize].width - 200)/2.0,inquiryButtonOriginY,200,30);
		_inquiryButton.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
		
		label0.frame = CGRectMake(10,offset_y,100,40);
		label0.font = [UIFont boldSystemFontOfSize:19];
		
		label1.frame = CGRectMake(10, offset_y + 60, 100, 40);
		label1.font = [UIFont boldSystemFontOfSize:19];

	}
	else 
	{
		offset_y = 40.0;
		_selectExpressButton.frame = CGRectMake(120,offset_y,400,60);
		_selectExpressButton.titleLabel.font = [UIFont boldSystemFontOfSize: 26];
		_inputTF.frame = CGRectMake(120, offset_y + 120, 400, 60);
		_inputTF.font = [UIFont systemFontOfSize: 30];
        
        _scanButton.frame = CGRectMake(120+400+30, offset_y + 120, 60, 60);
        
        CGFloat inquiryButtonOriginY = self.view.frame.size.height - 90.0 - 40.0;
		_inquiryButton.frame = CGRectMake(([RCTool getScreenSize].width - 500)/2.0,inquiryButtonOriginY,500,40);
		_inquiryButton.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
		
		label0.frame = CGRectMake(20,offset_y,200,60);
		label0.font = [UIFont boldSystemFontOfSize:30];
		
		label1.frame = CGRectMake(20, offset_y + 120, 400, 60);
		label1.font = [UIFont boldSystemFontOfSize:30];
	}
}

- (void)clickSelectExpressButton:(id)sender
{
	NSLog(@"clickSelectExpressButton");
	
	FDSelectExpressViewController* temp = [[FDSelectExpressViewController alloc] initWithNibName:nil
																						  bundle:nil];
	temp._delegate = self;
	UINavigationController* tempNavigationController = [[UINavigationController alloc] initWithRootViewController:temp];
    tempNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
	[temp release];

	[self presentModalViewController:tempNavigationController animated:YES];
    [tempNavigationController release];

}

- (void)clickedScanButton:(id)sender
{
    NSLog(@"clickedScanButton");
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [RCTool playSound:@"done.caf"];
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    NSLog(@"code:%@",symbol.data);
    if(_inputTF)
        _inputTF.text = symbol.data;
    

    [reader dismissModalViewControllerAnimated: YES];
}

- (void)clickInquiryButton:(id)sender
{
	NSLog(@"clickInquiryButton");
	
	[_inputTF resignFirstResponder];
	
	if(nil == _selectedExpress || 0 == [_selectedExpress.code length])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请选择快递公司" 
													   delegate:nil 
											  cancelButtonTitle:@"确定" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	if(0 == [_inputTF.text length])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"请输入快递单号" 
													   delegate:nil 
											  cancelButtonTitle:@"确定" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	if([RCTool isReachableViaInternet])
	{
		NSString* code = _selectedExpress.code;
		NSString* number = _inputTF.text; //1200425301357
		NSString* key = [RCTool getKey];
        NSString* valicode = nil;
        
        [RCTool addRecentExpress:code];
        
        //佳吉物流需要传递valicode参数，查询快递的电话号码
        if([code isEqualToString:@"jiajiwuliu"])
        {
            valicode = @"13982260600";
        }
        
		NSString* urlString = @"http://api.kuaidi100.com/api";
        NSMutableDictionary* token = [[NSMutableDictionary alloc] init];
        if([code length])
            [token setObject:code forKey:@"com"];
        if([number length])
            [token setObject:number forKey:@"nu"];
        if([key length])
            [token setObject:key forKey:@"id"];
        if([valicode length])
            [token setObject:valicode forKey:@"valicode"];
        
		RCInquiryHttpRequest* temp = [RCInquiryHttpRequest sharedInstance];
		[temp request:urlString delegate:self token:token];
        [token release];
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"对不起"
														message: @"连接网络失败，请检查网络。"
													   delegate: self
											  cancelButtonTitle: @"确定"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	


}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow: (NSNotification*)notification
{
//	NSDictionary *userInfo = [notification userInfo];
//	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//	//CGRect keyboardRect = [aValue CGRectValue];
//	
//	[UIView beginAnimations:@"keyboardWillShow" context:UIGraphicsGetCurrentContext()];
//	[UIView setAnimationDuration:0.3];
	
//	if(NO == [RCTool isIpad])
//	{
//		CGRect rect = _scrollView.frame;
//		rect.size.height = 460 - keyboardRect.size.height - 44;
//		_scrollView.frame = rect;
//	}
//	else
//	{
//		CGRect rect = _scrollView.frame;
//		rect.size.height = 1004 - keyboardRect.size.height - 44;
//		_scrollView.frame = rect;
//	}
	
//	[UIView commitAnimations];
	
}

- (void)keyboardWillHide: (NSNotification*)notification
{
	[UIView beginAnimations:@"keyboardWillHide" context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationDuration:0.3];
	
//	if(NO == [RCTool isIpad])
//	{
//		CGRect rect = _scrollView.frame;
//		rect.size.height = 460 - 44 - 50;
//		_scrollView.frame = rect;
//	}
//	else
//	{
//		CGRect rect = _scrollView.frame;
//		rect.size.height = 1004 - 44 - 50;
//		_scrollView.frame = rect;
//	}
	
	[UIView commitAnimations];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[_inputTF resignFirstResponder];
	return YES;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{ 
    //CGPoint touchPoint= [gesture locationInView:scrollView];
	
	[_inputTF resignFirstResponder];
}

- (void) willStartHttpRequest: (id)token;
{
	UIWindow* frontWindow = [RCTool frontWindow];
	[frontWindow addSubview: _indicator];
	[_indicator show:YES];
}

- (void)didFinishHttpRequest:(id)result token:(id)token
{
	[_indicator hide:YES];
	
	NSDictionary* dict = (NSDictionary*)result;
	if(nil == dict)
		return;
	
	//status： 结果状态（返回0、1和408。0，表示无查询结果；1，表示查询成功 ）
    
    //state:快递单当前的状态 。0：在途中,1：已发货，2：疑难件，3： 已签收 ，4：已退货。

	NSString* status = [dict objectForKey:@"status"];
	if(NO == [status isEqualToString:@"1"])
	{
		NSString* message = [dict objectForKey:@"message"];
		if(0 == [message length])
			message = @"无查询结果,请确认快递单号填写正确。";
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" 
														message:message 
													   delegate:nil 
											  cancelButtonTitle:@"确定" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	
	NSString* num = _inputTF.text;
	NSString* code = _selectedExpress.code;
	NSString* name = _selectedExpress.name;
	NSString* time = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
	NSRange range = [time rangeOfString:@"."];
	if(NSNotFound == range.location)
		time = [time substringToIndex:range.location];
	
	_selectedExpress.num = num;
	//_inputTF.text = @"";
	
	NSManagedObjectContext* insertionContext = [RCTool getManagedObjectContext];
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"code = %@ && num = %@",code,num];
	NSManagedObjectID* objectID = [RCTool getExistingEntityObjectIDForName: @"Record"
																 predicate: predicate
														   sortDescriptors: nil
																   context: insertionContext];
	
	
	Record* record = nil;
	if(nil == objectID)
	{
		record = [RCTool insertEntityObjectForName:@"Record" 
							   managedObjectContext:insertionContext];
	}
	else
	{
		record = (Record*)[RCTool insertEntityObjectForID:objectID
									   managedObjectContext:insertionContext];
	}

	record.name = name;
	record.code = code;
	record.num = num;
	record.time = time;
	record.isHidden = [NSNumber numberWithBool:NO];

	[RCTool saveCoreData];
	
	[RCTool saveResult:dict time:time];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateContent" 
														object:nil];
	
	FDResultViewController* temp = [[FDResultViewController alloc] initWithNibName:@"FDResultViewController"
																			bundle:nil];
	[temp updateContent: record];
	[self.navigationController pushViewController:temp animated:YES];
	[temp release];
	
}

- (void) didFailHttpRequest: (id)token
{
	[_indicator hide:YES];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" 
													message:@"查询失败，请检查网络。" 
												   delegate:nil 
										  cancelButtonTitle:@"确定" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(11 == alertView.tag)
	{
		if(1 == buttonIndex)
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum]]];
		}
	}
	else if(12 == alertView.tag)
	{
		if(1 == buttonIndex)
		{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_web]];
		}
	}
}

#pragma mark -
#pragma mark OHAttributedLabelDelegate Delegate

- (void)clickLinkText:(NSString*)linkText token:(id)token
{
    NSLog(@"clickLinkText:%@",linkText);
	int tag = [(NSNumber*)token intValue];
	
	{
		if(110 == tag)
		{
			if([RCTool isIpad])
				return;
			
			NSString* phoneNum = [_selectedExpress.phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
			phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"－" withString:@""];
			self._phoneNum = phoneNum;
			
			NSString* message = [NSString stringWithFormat:@"即将拨打%@公司电话:%@，是否确定?",_selectedExpress.name,_selectedExpress.phoneNum];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:message 
														   delegate:self 
												  cancelButtonTitle:@"取消"
												  otherButtonTitles:@"确定",nil];
			alert.delegate = self;
			alert.tag = 11;
			[alert show];
			[alert release];
		}
		else if(111 == tag)
		{
			self._web = _selectedExpress.web;
			
			NSString* message = [NSString stringWithFormat:@"即将访问%@公司网站，是否确定?",_selectedExpress.name];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
															message:message 
														   delegate:self 
												  cancelButtonTitle:@"取消"
												  otherButtonTitles:@"确定",nil];
			alert.delegate = self;
			alert.tag = 12;
			[alert show];
			[alert release];
		}
	}

}

- (UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    return LINK_COLOR;
}

- (UIFont*)fontForLink:(id)token
{
	if(NO == [RCTool isIpad])
		return LINK_FONT;
	else 
		return [UIFont systemFontOfSize:30];

}

@end
