    //
//  FDSelectExpressViewController.m
//  Food
//
//  Created by xuzepei on 12/18/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import "FDSelectExpressViewController.h"
#import "RCTool.h"
#import "Express.h"

@implementation FDSelectExpressViewController
@synthesize _tableView;
@synthesize _itemArray;
@synthesize _searchArray;
@synthesize _searchBar;
@synthesize _searchController;
@synthesize fetchedResultsController;
@synthesize fetchedResultsController2;
@synthesize _delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		self.title = NSLocalizedString(@"请选择快递公司",@"");
		
		UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											  target:self
											  action:@selector(clickCancelButtonItem:)];
		self.navigationItem.leftBarButtonItem = leftBarButtonItem;
		[leftBarButtonItem release];
		
		_itemArray = [[NSMutableArray alloc] init];
		_searchArray = [[NSMutableArray alloc] init];
		
//        self.view.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT);
		
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
    
//        self.view.frame = CGRectMake(0,0,[RCTool getScreenSize].width,[RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
	
    [self initTableView];
    
	[self updateContent];
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
	self._searchBar = nil;
	self._searchController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self._tableView = nil;
	self._searchBar = nil;
	self._searchController = nil;
}


- (void)dealloc {
	
	[_delegate release];
	[_itemArray release];
	[_searchArray release];
	self._tableView = nil;
	self._searchBar = nil;
	self._searchController = nil;
	[fetchedResultsController release];
	[fetchedResultsController2 release];
	
    [super dealloc];
}

- (void)initTableView
{
	//init table view
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
	
	[self.view addSubview:_tableView];
}

- (void)updateContent
{
	NSFetchedResultsController* temp = [self fetchedResultsController];
	if(nil == temp)
		return;
	
	NSArray* sections = [temp sections];
	
	if([sections count])
	{
		[_itemArray addObjectsFromArray: sections];
		[_tableView reloadData];
	}
	
}

- (void)clickCancelButtonItem:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark search bar delegate

- (void)searchBar:(UISearchBar *)searchBar 
	textDidChange:(NSString *)searchText
{
	
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	if([searchString length])
	{
		//		NSMutableArray* tempArray = [[NSMutableArray alloc] init];
		//		for(Express* express in _itemArray)
		//		{
		//			NSRange range = [express.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
		//			if(range.location != NSNotFound)
		//				[tempArray addObject:express];
		//		}
		//		
		//		[_searchArray removeAllObjects];
		//		[_searchArray addObjectsFromArray: tempArray];
		//		[tempArray release];
		
		[self searchObjects: searchString];
	}
	
	return YES;
}


#pragma mark -
#pragma mark UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if(tableView == _tableView)
    {
        NSArray* recentExpressArray = [RCTool getRecentExpress];
        if([recentExpressArray count])
            return [_itemArray count] + 1;
        else
            return [_itemArray count];
    }
	else
		return [[fetchedResultsController2 sections] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == _tableView)
    {
        NSArray* expressArray = [self.fetchedResultsController fetchedObjects];
        
        NSMutableSet* set =  [[NSMutableSet alloc] init];
        for(Express* express in expressArray)
        {
            [set addObject: express.type];
        }
        
        NSArray* array = [set allObjects];
        array = [array sortedArrayUsingSelector:@selector(compare:)];
        [set release];
        
        NSArray* recentExpressArray = [RCTool getRecentExpress];
        if([recentExpressArray count])
        {
            NSMutableArray* temp = [[[NSMutableArray alloc] init] autorelease];
            [temp addObject:@"*"];
            [temp addObjectsFromArray:array];
            return temp;
        }
        
        return array;
    }
    
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
	if(tableView == _tableView)
	{
        NSArray* recentExpressArray = [RCTool getRecentExpress];
        if([recentExpressArray count])
        {
            if(0 == section)
                return @"最近选择";
            
            NSArray* array = [[[fetchedResultsController sections] objectAtIndex:section - 1] objects];
            Express* express = [array objectAtIndex:0];
            return express.type;
        }
        else
        {
            NSArray* array = [[[fetchedResultsController sections] objectAtIndex:section] objects];
            Express* express = [array objectAtIndex:0];
            return express.type;
        }
	}
	else
	{
		NSArray* array = [[[fetchedResultsController2 sections] objectAtIndex:section] objects];
		Express* express = [array objectAtIndex:0];
		return express.type;
	}
}

- (id)getCellDataAtIndexPath: (NSIndexPath*)indexPath tableView:(UITableView *)tableView
{
	if(tableView == _tableView)
	{
        NSArray* recentExpressArray = [RCTool getRecentExpress];
        if([recentExpressArray count])
        {
            if(0 == indexPath.section)
            {
                NSString* code = [recentExpressArray objectAtIndex:indexPath.row];
                if([code length])
                {
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"code=%@",code];
                    NSArray* expressArray = [RCTool getExistingEntityObjectsForName:@"Express"
                                                                          predicate:predicate
                                                                    sortDescriptors:nil];
                    
                    if([expressArray count])
                        return [expressArray lastObject];
                }
                
                return nil;
            }
            
            NSArray* array = [[[fetchedResultsController sections] objectAtIndex:indexPath.section - 1] objects];
            Express* express = [array objectAtIndex:indexPath.row];
            return express;
        }
        else
        {
            NSArray* array = [[[fetchedResultsController sections] objectAtIndex:indexPath.section] objects];
            Express* express = [array objectAtIndex:indexPath.row];
            return express;
        }
        
	}
	else
	{
		NSArray* array = [[[fetchedResultsController2 sections] objectAtIndex:indexPath.section] objects];
		Express* express = [array objectAtIndex:indexPath.row];
		return express;
	}
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if(tableView == _tableView)
    {
        NSArray* recentExpressArray = [RCTool getRecentExpress];
        if([recentExpressArray count])
        {
            if(0 == section)
                return [recentExpressArray count];
            else
            {
                return [[[fetchedResultsController sections] objectAtIndex:section - 1] numberOfObjects];
            }
        }
        else
        {
            return [[[fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
        }
    }
	else
		return [[[fetchedResultsController2 sections] objectAtIndex:section] numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(NO == [RCTool isIpad])
		return 60.0;
	else 
		return 80.0;
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
    }
	
	Express* express = (Express*)[self getCellDataAtIndexPath:indexPath tableView:tableView];
	if(express)
	{
                cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",express.code]];
        
		if(NO == [RCTool isIpad])
		{
			cell.textLabel.font = [UIFont systemFontOfSize:20];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
		}
		else {
			cell.textLabel.font = [UIFont systemFontOfSize:24];
			cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
		}
		
		
		cell.textLabel.text = express.name;
		cell.detailTextLabel.text = express.phoneNum;
	}
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	Express* express = [self getCellDataAtIndexPath:indexPath tableView:tableView];
	if(express)
	{
		if(_delegate && [_delegate respondsToSelector:@selector(updateSelectedExpress:)])
		{
			[[NSUserDefaults standardUserDefaults] setObject:express.id 
													  forKey:@"default_select"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[_delegate updateSelectedExpress: express];
		}
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

#pragma mark -
- (NSFetchedResultsController *)fetchedResultsController {
	
	if (nil == fetchedResultsController) 
	{
		NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isHidden == NO"];
		NSSortDescriptor* sortDescriptor0 = [[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease];
		NSSortDescriptor* sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
		
		NSManagedObjectContext* context = [RCTool getManagedObjectContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Express"
												  inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
		
		[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor0,sortDescriptor1,nil]];
		
		//set predicate
		[fetchRequest setPredicate:predicate];
		
		//设置返回类型
		[fetchRequest setResultType:NSManagedObjectResultType];
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
																 initWithFetchRequest:fetchRequest 
																 managedObjectContext:context 
																 sectionNameKeyPath:@"type" 
																 cacheName:nil];
		
		[aFetchedResultsController performFetch:nil];
		
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
        [fetchRequest release];
    }
	
	return fetchedResultsController;
}


- (NSFetchedResultsController *)searchObjects:(NSString*)searchText
{
	//if (nil == fetchedResultsController) 
	{
		NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isHidden == NO && name contains[cd] %@",searchText];
		NSSortDescriptor* sortDescriptor0 = [[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease];
		NSSortDescriptor* sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
		
		NSManagedObjectContext* context = [RCTool getManagedObjectContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Express"
												  inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
		
		[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor0,sortDescriptor1,nil]];
		
		//set predicate
		[fetchRequest setPredicate:predicate];
		
		//设置返回类型
		[fetchRequest setResultType:NSManagedObjectResultType];
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
																 initWithFetchRequest:fetchRequest 
																 managedObjectContext:context 
																 sectionNameKeyPath:@"type" 
																 cacheName:nil];
		
		[aFetchedResultsController performFetch:nil];
		
		self.fetchedResultsController2 = aFetchedResultsController;
		
		[aFetchedResultsController release];
        [fetchRequest release];
    }
	
	return fetchedResultsController;
}




@end
