//
//  FDFavoriteViewController.m
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import "FDFavoriteViewController.h"
#import "Food.h"
#import "FDResultViewController.h"
#import "RCTool.h"
#import "RCInquiryHttpRequest.h"

@implementation FDFavoriteViewController
@synthesize _tableView;
@synthesize _itemArray;
@synthesize _indicator;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateContent:)
													 name:@"updateContent" 
												   object:nil];
		
		
		UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@""
														   image:[UIImage imageNamed:@"history.png"]
															 tag: TT_FAVORITE];
		self.tabBarItem = item;
		[item release];
		
		self.title = NSLocalizedString(@"近期查询",@"");
		
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
		_itemArray = [[NSMutableArray alloc] init];
		
		_indicator = [[MBProgressHUD alloc] initWithWindow:[RCTool frontWindow]];
		_indicator.labelText = @"正在查询...";
		
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.view.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT);
    
    [self initTableView];
    
    [self updateContent:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self updateContent:nil];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    
    self._tableView = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self._tableView = nil;
}


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_itemArray release];
	self._tableView = nil;
    self.selectedRecord = nil;
    self._indicator = nil;
	
    [super dealloc];
}

- (void)initTableView
{
	//init table view
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
    }
	//_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[self.view addSubview:_tableView];
}

- (void)updateContent:(NSNotification*)notification
{
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isHidden == NO"];
	NSSortDescriptor* sortDescriptor0 = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
	NSArray* recordArray = [RCTool getExistingEntityObjectsForName:@"Record"
													   predicate:predicate
												 sortDescriptors:[NSArray arrayWithObjects: sortDescriptor0,nil]];
	[sortDescriptor0 release];
	
	[_itemArray removeAllObjects];
	
	if([recordArray count])
	{
		[_itemArray addObjectsFromArray: recordArray];
	}
	
	//[self updateBadge];
	
	[_tableView reloadData];
	
}

- (void)updateBadge
{
	NSString* badgeValue = nil;
	if([_itemArray count])
	{
		badgeValue = [NSString stringWithFormat:@"%d",[_itemArray count]];
	}
	
	self.tabBarItem.badgeValue = badgeValue;
}

#pragma mark -
#pragma mark UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath tableView:(UITableView *)tableView
{
	if(indexPath.row >= [_itemArray count])
		return nil;
	
	return [_itemArray objectAtIndex: indexPath.row];
}

- (void)removeItemByIndexPath:(NSIndexPath*)indexPath
{
	if(indexPath.row >= [_itemArray count])
		return;
	
	[_itemArray removeObjectAtIndex:indexPath.row];
	
	[self updateBadge];
	
	return;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [_itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(NO == [RCTool isIpad])
		return 70.0;
	else 
		return 90.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle 
									   reuseIdentifier: cellId] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		if([RCTool isIpad])
		{
			cell.textLabel.font = [UIFont systemFontOfSize:24];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
		}
		else
		{
			cell.detailTextLabel.numberOfLines = 2;
		}

    }
	
	Record* record = (Record*)[self getCellDataAtIndexPath:indexPath tableView:tableView];
	if(record)
	{
		cell.textLabel.text = record.name;
		double time = [record.time doubleValue];
		NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
		NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		//dateFormatter.dateStyle = NSDateFormatterShortStyle;
		dateFormatter.dateFormat = @"yy-MM-dd H:m:s";
		//[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
		NSString* temp = [dateFormatter stringFromDate:date];
		//return temp;
		
		if([RCTool isIpad])
		{
			cell.detailTextLabel.text = [NSString stringWithFormat:@"单号:%@    时间:%@",record.num,temp];
		}
		else 
		{
			cell.detailTextLabel.text = [NSString stringWithFormat:@"单号:%@\r时间:%@",record.num,temp];
		}

	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	Record* record = [self getCellDataAtIndexPath:indexPath tableView:tableView];
	if(record)
	{
        self.selectedRecord = record;
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate: self
                                                        cancelButtonTitle: NSLocalizedString(@"取消",@"")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:
                                      @"查看",@"刷新",@"复制单号",@"通过邮件发送",@"通过短信发送",nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.tag = 0;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        //[actionSheet showInView:self.];
        [actionSheet release];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:YES];
	
	_cellEditing = editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
	if(cell)
	{
		Record* record = [self getCellDataAtIndexPath:indexPath tableView:tableView];
		if(record)
			record.isHidden = [NSNumber numberWithBool:YES];
		
		[self removeItemByIndexPath:indexPath];
		[_tableView reloadData];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.editing == NO) 
		return UITableViewCellEditingStyleNone;
	
	return UITableViewCellEditingStyleDelete;
}

- (void)checkRecord
{
    if(nil == self.selectedRecord)
        return;
    
    NSDictionary* dict = [RCTool getResult:self.selectedRecord.time];
    if(nil == dict)
        return;
    
    FDResultViewController* temp = [[FDResultViewController alloc] initWithNibName:@"FDResultViewController"
                                                                            bundle:nil];
    [temp updateContent: self.selectedRecord];
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
}

- (void)updateRecord
{
    if(nil == self.selectedRecord)
        return;
    
    NSDictionary* dict = [RCTool getResult:self.selectedRecord.time];
    if(nil == dict)
        return;
    
    NSString* state = [dict objectForKey:@"state"];
    if([state isEqualToString:@"3"])//已签收，直接查看，不需要更新
    {
        [self checkRecord];
        return;
    }
    
    if([RCTool isReachableViaInternet])
	{
		NSString* code = self.selectedRecord.code;
		NSString* number = self.selectedRecord.num;
		NSString* key = [RCTool getKey];
        NSString* valicode = nil;
        
        
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

- (void)copyNumberFromRecord
{
    if(nil == self.selectedRecord)
        return;
    
    NSString* num = self.selectedRecord.num;
    if([num length])
    {
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:num];
    }
}

- (void)sendRecordByEmail
{
    if(nil == self.selectedRecord)
        return;
    
    NSDictionary* dict = [RCTool getResult:self.selectedRecord.time];
    if(nil == dict)
        return;
    
    NSArray* data = [dict objectForKey:@"data"];
	if(0 == [data count])
        return;
    
    NSString* context = [[data objectAtIndex:0] objectForKey:@"context"];
    if(0 == [context length])
        return;
    
    NSString* time = [[data objectAtIndex:0] objectForKey:@"time"];
    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
        
        compose.mailComposeDelegate = self;
        
        NSString* title = [NSString stringWithFormat:@"%@ 单号:%@",self.selectedRecord.name,self.selectedRecord.num];
        [compose setSubject:title];
        
        [compose setMessageBody:[NSString stringWithFormat:@"快递最新状态: %@ 时间: %@",context,time] isHTML:NO];
        
        [self presentModalViewController:compose animated:YES];
        
        [compose release];
    }
    else {
        [RCTool showAlert:@"提示" message:@"不能发送邮件，请检查系统邮件设置。"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if(MFMailComposeResultSent == result)
    {
        [RCTool showAlert:@"提示" message:@"邮件已成功发送!"];
    }
    
	[controller dismissModalViewControllerAnimated:YES];
}

- (void)sendRecordBySMS
{
    if(nil == self.selectedRecord)
        return;
    
    NSDictionary* dict = [RCTool getResult:self.selectedRecord.time];
    if(nil == dict)
        return;
    
    NSArray* data = [dict objectForKey:@"data"];
	if(0 == [data count])
        return;
    
    NSString* context = [[data objectAtIndex:0] objectForKey:@"context"];
    if(0 == [context length])
        return;
    
    NSString* time = [[data objectAtIndex:0] objectForKey:@"time"];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if(messageClass)
    {
        if(NO == [MFMessageComposeViewController canSendText])
        {
            [RCTool showAlert:@"提示" message:@"设备没有短信功能"];
            return;
        }
    }
    else
    {
        [RCTool showAlert:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
        return;
    }
    
    MFMessageComposeViewController* compose = [[MFMessageComposeViewController alloc] init];
    
    compose.messageComposeDelegate = self;
    
    NSString* title = [NSString stringWithFormat:@"%@ 单号:%@",self.selectedRecord.name,self.selectedRecord.num];
    compose.body = [NSString stringWithFormat:@"%@,最新状态: %@ 时间: %@",title,context,time];
    
    [self presentModalViewController:compose animated:YES];
    //[[[[compose viewControllers] lastObject] navigationItem] setTitle:@"SomethingElse"];//修改短信界面标题
    [compose release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
        {
            [RCTool showAlert:@"提示" message:@"短信已成功发送!"];
            break;
        }
        default:
            break;
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(0 == actionSheet.tag)
	{
		if(0 == buttonIndex)
		{
			[self checkRecord];
		}
        else if(1 == buttonIndex)
        {
            [self updateRecord];
        }
        else if(2 == buttonIndex)
        {
            [self copyNumberFromRecord];
        }
        else if(3 == buttonIndex)
        {
            [self sendRecordByEmail];
        }
        else if(4 == buttonIndex)
        {
            [self sendRecordBySMS];
        }
	}
}

#pragma mark - RCInquiryHttpRequestDelegate

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
	
	
	NSString* num = self.selectedRecord.num;
	NSString* code = self.selectedRecord.code;
	NSString* name = self.selectedRecord.name;
    
	NSString* time = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
	NSRange range = [time rangeOfString:@"."];
	if(NSNotFound == range.location)
		time = [time substringToIndex:range.location];
	
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
    
    if(_tableView)
        [_tableView reloadData];
	
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



@end
