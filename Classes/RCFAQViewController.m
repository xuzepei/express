//
//  RCFAQViewController.m
//  Emoji2
//
//  Created by zepei xu on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCFAQViewController.h"

@interface RCFAQViewController ()

@end

@implementation RCFAQViewController
@synthesize _itemArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self updateContent];
    }
    return self;
}

- (void)dealloc
{
    self._itemArray = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"FAQ常见问题", @"");
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateContent
{
    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"1. 查询失败?" forKey:@"question"];
    [dict setObject:@"首先请核对快递公司与单号是否正确一致；其次如果快递包裹刚被签收，需要一定时间才能查询最新状态；EMS／平邮等可能需要2-3天才可查询。" forKey:@"answer"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"index"];
    [_itemArray addObject: dict];
    [dict release];
    
    
    dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"2. 查询淘宝的物流编号?" forKey:@"question"];
    [dict setObject:@"［LP］开头的是淘宝的物流编号，不是快递单号，请向卖家问询真实的快递单号。" forKey:@"answer"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"index"];
    [_itemArray addObject: dict];
    [dict release];
}

#pragma mark - Table view data source

- (NSDictionary*)getCellDataAtIndexPath:(NSIndexPath*)indexPath tableView:(UITableView *)tableView
{
    if(indexPath.section >= [_itemArray count])
        return nil;
    
    return [_itemArray objectAtIndex:indexPath.section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_itemArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.row)
    {
        return 60.0;
    }
    else if(1 == indexPath.row)
    {
        return 90.0;
    }
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId1 = @"cellId1";
    UITableViewCell *cell = nil;
    
    NSDictionary* dict = [self getCellDataAtIndexPath:indexPath tableView:tableView];


    if(0 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
        if (nil == cell) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId0] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.numberOfLines = 4;
        }
        
        if(dict)
        {
            cell.textLabel.text = [dict objectForKey:@"question"];
        }

    }
    else if(1 == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (nil == cell) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                           reuseIdentifier: cellId1] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 4;
        }
        
        if(dict)
        {
            cell.textLabel.text = [dict objectForKey:@"answer"];
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
