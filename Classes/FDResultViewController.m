//
//  FDResultViewController.m
//  Food
//
//  Created by xuzepei on 12/19/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import "FDResultViewController.h"
#import "RCTool.h"


#define COLOR_0 [UIColor colorWithHue:0.10 saturation:0.95 brightness:1.00 alpha:1.00]
#define COLOR_1 [UIColor colorWithRed:0.33 green:0.94 blue:1.00 alpha:1.00]
#define COLOR_2 [UIColor colorWithRed:1.00 green:0.09 blue:0.09 alpha:1.00]
#define COLOR_3 [UIColor colorWithRed:0.04 green:0.38 blue:0.04 alpha:1.00]
#define COLOR_4 [UIColor colorWithRed:1.00 green:0.09 blue:0.09 alpha:1.00]

@implementation FDResultViewController
@synthesize _tableView;
@synthesize _itemArray;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		self.title = NSLocalizedString(@"查询结果",@"");
		
		_itemArray = [[NSMutableArray alloc] init];
		
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - 75.0 - TAB_BAR_HEIGHT);
    
    [self initTableView];
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
	
	[_itemArray release];
	[_tableView release];
    self.result = nil;
    self.record = nil;
	
    [super dealloc];
}

- (void)initTableView
{
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
	
}

- (void)updateContent:(Record*)aRecord
{
    self.record = aRecord;
    NSDictionary* dict = [RCTool getResult:self.record.time];
    if(nil == dict)
        return;
    
    self.result = dict;
    NSString* temp = nil;
    NSString* state = [dict objectForKey:@"state"];
    if([state isEqualToString:@"0"])
    {
        temp = @"快递单最新状态: 在途中";
    }
    else if([state isEqualToString:@"1"])
    {
        temp = @"快递单最新状态: 已发货";
    }
    else if([state isEqualToString:@"2"])
    {
        temp = @"快递单最新状态: 疑难件";
    }
    else if([state isEqualToString:@"3"])
    {
        temp = @"快递单最新状态: 已签收";
    }
    else if([state isEqualToString:@"4"])
    {
        temp = @"快递单最新状态: 已退货";
    }
    
    if([temp length])
        self.navigationItem.prompt = temp;
    
	NSArray* data = [self.result objectForKey:@"data"];
	if([data count])
	{
		[_itemArray removeAllObjects];
		[_itemArray addObjectsFromArray: data];
		[_tableView reloadData];
	}
	

}

- (void)clickRefreshBarButtonItem:(id)sender
{
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

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [_itemArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(NO == [RCTool isIpad])
		return 80.0;
	else 
		return 100.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle 
									   reuseIdentifier: cellId] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.03 green:0.51 blue:1.00 alpha:1.00];
		
		if(NO == [RCTool isIpad])
		{
			cell.textLabel.font = [UIFont systemFontOfSize:16];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
		}
		else 
		{
			cell.textLabel.font = [ UIFont systemFontOfSize:24];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:20];
			
		}
    }
	
	NSDictionary* dict = (NSDictionary*)[self getCellDataAtIndexPath:indexPath tableView:tableView];
	if(dict)
	{
        if(0 == indexPath.row)
        {
            NSString* state = [self.result objectForKey:@"state"];
            if([state isEqualToString:@"0"])
            {
                cell.textLabel.textColor = COLOR_0;
            }
            else if([state isEqualToString:@"1"])
            {
                cell.textLabel.textColor = COLOR_1;
            }
            else if([state isEqualToString:@"2"])
            {
                cell.textLabel.textColor = COLOR_2;
            }
            else if([state isEqualToString:@"3"])
            {
                cell.textLabel.textColor = COLOR_3;
            }
            else if([state isEqualToString:@"4"])
            {
                cell.textLabel.textColor = COLOR_4;
            }
            else
                cell.textLabel.textColor = [UIColor blackColor];
            
            NSString* str = [NSString stringWithFormat:@"最新状态: %@",[dict objectForKey:@"context"]];
            cell.textLabel.text = str;
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [dict objectForKey:@"context"];
        }
        

		cell.textLabel.numberOfLines = 3;
		cell.detailTextLabel.text = [dict objectForKey:@"time"];
		cell.detailTextLabel.numberOfLines = 1;
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}




@end
