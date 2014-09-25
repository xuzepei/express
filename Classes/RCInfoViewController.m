//
//  RCInfoViewController.m
//  Emoji2
//
//  Created by zepei xu on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCInfoViewController.h"
#import "RCTool.h"
#import "RCFAQViewController.h"
#import "RCImageLoader.h"

#define SECTION_HELP 0
#define SECTION_OTHERAPP 1

@interface RCInfoViewController (Private)

- (void)sendByEmail;

@end

@implementation RCInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.itemArray = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestContent];
}

- (void)requestContent
{
    [_itemArray removeAllObjects];
    
    NSArray* otherApps = [RCTool getOtherApps];
    if(otherApps && [otherApps isKindOfClass:[NSArray class]])
    {
        if([otherApps count])
            [_itemArray addObjectsFromArray:otherApps];
    }
    
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"Info", @"");
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

#pragma mark - Table view data source

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath
{
    if(1 == indexPath.section)
    {
        if(indexPath.row >= [_itemArray count])
            return nil;
        
        return [_itemArray objectAtIndex: indexPath.row];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section)
        return 1;
    else
        return [_itemArray count];
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(0 == section)
        return NSLocalizedString(@"帮助", @"");
    else if(1 == section && [_itemArray count])
        return @"精选应用游戏推荐";
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([RCTool isIpad])
    {
        if(0 == indexPath.section)
            return 70.0f;
        else if(1 == indexPath.section)
            return 70.0f;
    }
    else{
        if(0 == indexPath.section)
            return 60.0f;
        else if(1 == indexPath.section)
            return 60.0f;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId0 = @"cellId0";
    static NSString *cellId2 = @"cellId2";
    UITableViewCell *cell = nil;
    
    if(SECTION_HELP == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId0];
            if (nil == cell) 
            {
                cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                               reuseIdentifier: cellId0] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = NSLocalizedString(@"FAQ常见问题", @"");
                
            }
        }
    }
    else if(SECTION_OTHERAPP == indexPath.section)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (nil == cell) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                           reuseIdentifier: cellId2] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath:indexPath];
        if(item)
        {
            cell.textLabel.text = [item objectForKey:@"name"];
            
            NSString* imageUrl = [item objectForKey:@"img_url"];
            if([imageUrl length])
            {
                UIImage* image = [RCTool getImageFromLocal:imageUrl];
                if(image)
                {
                    image = [RCTool imageWithImage:image scaledToSize:CGSizeMake(40.0, 40.0)];
                    cell.imageView.image = image;
                }
                else
                {
                    [[RCImageLoader sharedInstance] saveImage:imageUrl
                                                     delegate:self
                                                        token:nil];
                }
            }
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
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if(SECTION_HELP == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            RCFAQViewController* temp = [[RCFAQViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:temp animated:YES];
            [temp release];
        }
        else if(1 == indexPath.row)
        {
            [self sendByEmail];
        }
    }
    else if(SECTION_OTHERAPP == indexPath.section)
    {
        NSDictionary* item = (NSDictionary*)[self getCellDataAtIndexPath:indexPath];
        if(item)
        {
            NSString* urlString = [item objectForKey:@"url"];
            if([urlString length])
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessoryButtonTappedForRowWithIndexPath");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
}


- (void)sendByEmail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
        
        compose.mailComposeDelegate = self;
        
        [compose setToRecipients:[NSArray arrayWithObject:@"intelligentapps@gmail.com"]];
        
        NSMutableString* subject = [[[NSMutableString alloc] init] autorelease];
        [subject appendString:FEEDBACK_EMAIL_TITLE];
        [subject appendFormat:@",v%@",APP_VERSION];
        [subject appendFormat:@" ,iOS %.2f",[RCTool systemVersion]];
        [subject appendFormat:@" ,device %d",UI_USER_INTERFACE_IDIOM()];
        
        [compose setSubject:subject];
        
        [compose setMessageBody:@"请在来信中明确问题的情况，包括：\r\r1.如果未能成功查询，请写明快递公司和快递单号； \r\r2.如果无法找到对应的快递公司，请写明快递公司名称，我们会在新版本中尽力为您添加；" isHTML:NO];
        
        [self presentViewController:compose animated:YES completion:nil];
        
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
    
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)succeedLoad:(id)result token:(id)token
{
    [self.tableView reloadData];
}

@end
