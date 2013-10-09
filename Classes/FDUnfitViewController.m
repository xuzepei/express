//
//  FDUnfitViewController.m
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import "FDUnfitViewController.h"
#import "RCTool.h"
#import "FDPictureViewController.h"
#import "Express.h"

@implementation FDUnfitViewController
@synthesize _tableView;
@synthesize _itemArray;
@synthesize _searchArray;
@synthesize _searchBar;
@synthesize _searchController;
@synthesize fetchedResultsController;
@synthesize fetchedResultsController2;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@""
														   image:[UIImage imageNamed:@"list.png"]
															 tag: TT_UNFIT];
		self.tabBarItem = item;
		[item release];
		
		self.title = NSLocalizedString(@"快递列表",@"");
		
		_itemArray = [[NSMutableArray alloc] init];
		_searchArray = [[NSMutableArray alloc] init];
		
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	
//    CGFloat adHeight = 0.0;
//	UIView* adView = [RCTool getAdView];
//	if(adView)
//	{
//        adHeight = adView.bounds.size.height;
//		CGRect rect = adView.frame;
//        rect.origin.y = self.view.frame.size.height - adView.frame.size.height;
//		adView.frame = rect;
//		
//		[self.view addSubview:adView];
//	}
//    
//    if(_tableView)
//    {
//        _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - adHeight);
//        [_tableView reloadData];
//    }
    
    if(_infoButton)
        _infoButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_infoButton)
        [self.navigationController.navigationBar addSubview:_infoButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_infoButton)
        _infoButton.hidden = YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(nil == self.interstitial)
    {
        _interstitial = [[GADInterstitial alloc] init];
        _interstitial.adUnitID = AD_ID;
        _interstitial.delegate = self;
        [_interstitial loadRequest:[GADRequest request]];
    }
    

    [self initTableView];
	
	[self updateContent];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialDidReceiveAd");
    
    [self performSelector:@selector(showAD:) withObject:nil afterDelay:10];
}

- (void)showAD:(id)argument
{
    if(self.interstitial)
        [self.interstitial presentFromRootViewController:self];
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
    self.infoButton = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self._tableView = nil;
    self._searchBar = nil;
    self._searchController = nil;
    self.infoButton = nil;
}


- (void)dealloc {
	
	[_itemArray release];
	[_searchArray release];
    self._tableView = nil;
    self._searchBar = nil;
    self._searchController = nil;
    self.infoButton = nil;
	[fetchedResultsController release];
	[fetchedResultsController2 release];
    
    self.interstitial = nil;
	
    [super dealloc];
}

- (void)initTableView
{
	//init table view
    if(nil == _tableView)
    {
        CGFloat height = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT;
        if([RCTool systemVersion] >= 7.0)
            height = [RCTool getScreenSize].height;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[RCTool getScreenSize].width,height)
                                                  style:UITableViewStylePlain];
	}
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[self.view addSubview:_tableView];
    
    if(nil == _searchBar)
    {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
	_searchBar.barStyle = UIBarStyleDefault;
	_searchBar.placeholder = NSLocalizedString(@"输入快递名称搜索",@"");
	_searchBar.tintColor = [UIColor colorWithRed:0.74 green:0.77 blue:0.80 alpha:1.00];
	_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.delegate=self;
	_tableView.tableHeaderView = _searchBar;
	
    if(nil == _searchController)
    {
        _searchController = [[UISearchDisplayController alloc]
                             initWithSearchBar:_searchBar contentsController:self];
    }
    
	_searchController.delegate = self;
	_searchController.searchResultsDataSource = self;
	_searchController.searchResultsDelegate = self;
	
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
	
    if(nil == _infoButton)
    {
        self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.infoButton.frame = CGRectMake(0, 2, 44, 44);
        [self.infoButton addTarget:self action:@selector(clickedInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
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
        else{
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
			cell.detailTextLabel.font = [UIFont systemFontOfSize:20];
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
        //[RCTool addRecentExpress:express.code];
        
		FDPictureViewController *temp = [[FDPictureViewController alloc]
                                         initWithNibName:@"FDPictureViewController"
                                         bundle:nil];
        temp.updateTitle = YES;
		[temp updateSelectedExpress:express];
		[self.navigationController pushViewController:temp animated:YES];
		[temp release];
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

- (void)clickRightBarButtonItem:(id)sender
{
	
}

- (void)clickedInfoButton:(id)sender
{
    NSLog(@"clickedInfoButton");
    
    RCInfoViewController *temp = [[RCInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:temp animated:YES];
    [temp release];
}



@end
