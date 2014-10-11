//
//  JTNewsViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/7/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTNewsViewController.h"
#import "DocumentRoot.h"
#import "Element.h"
#import "JTParser.h"
#import "AFXMLRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "MBProgressHUD.h"
#import "PullToRefreshView.h"
#import "JTAppDelegate.h"
#import "JTCell.h"
#import "JTNewsDetailViewController.h"

@class MBProgressHUD;

@interface JTNewsViewController (PrivateMethods)

-(void)loadData;

@end

@implementation JTNewsViewController
@synthesize items;
@synthesize sView = _sView;
@synthesize JTTableView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
return YES;
}
return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


-(BOOL)shouldAutorotate{
    return YES;
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"News";
    
    [[LocalyticsSession shared] tagEvent:@"JTimes News"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading Jewish News";
	
	[HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
    
    NSURL *requestURL = [NSURL URLWithString:NSLocalizedString(@"NEWS",nil)];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest: request
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                                                                               XMLParser.delegate = self;
                                                                                               [XMLParser parse];
                                                                                           } failure:nil];
    
    NSOperation *queue = [[[NSOperationQueue alloc]init]autorelease];
    [queue addOperation:operation];
	
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
    [self.view setBackgroundColor:bgColor];
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.JTTableView];
    [pull setDelegate:self];
    [self.JTTableView addSubview:pull];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            break;
        }
    }
    
    [self.JTTableView setDelegate:self];
    [self.JTTableView setDataSource:self];
	// Do any additional setup after loading the view.
}

- (void)stripHTMLFromSummary {
    int i = 0;
    int count = self.items.count;
    //cycles through each 'summary' element stripping HTML
    while (i < count) {
        NSString *tempString = [[self.items objectAtIndex:i] objectForKey:@"summary"];
        NSMutableDictionary *dict = [self.items objectAtIndex:i];
        [dict setObject:tempString forKey:@"summary"];
        [self.items replaceObjectAtIndex:i withObject:dict];
        i++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self items];
}


- (void)viewDidAppear:(BOOL)animated{
    [self loadData];
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    if (items == nil) {
        
        JTParser *rssParser = [[JTParser alloc] init];
        [rssParser parseRssFeed:NSLocalizedString(@"NEWS",nil) withDelegate:self];
        
        [rssParser release];
    } else {
        [self.JTTableView reloadData];
    }
    sleep(1);
    [pull finishedLoading];
}

- (void)receivedItems:(NSArray *)theItems {
    items = theItems;
    [self.JTTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"TorahCell";
    JTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JTCell"];
    
    NSString *source = [[items objectAtIndex:indexPath.row] objectForKey:@"summary"];
    
    DocumentRoot *document = [Element parseHTML: source];
	Element *elements = [document selectElement: @"img"];
    NSString* fooAttr = [elements attribute: @"src"];
    
    NSString *snipet = [elements contentsText];
    snipet = ([snipet length]  > 5) ? [snipet substringToIndex: 5] : fooAttr;
    snipet = [[elements description] stringByAppendingFormat: @"%@", fooAttr];
    
    if (cell == nil) {
        cell = [[[JTCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JTCell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    [cell.blogImageView setImageWithURL:[NSURL URLWithString:fooAttr]
                       placeholderImage:[UIImage imageNamed:@"iTunesArtwork@2x.png"]];
    cell.blogTitle.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *comments = [NSString stringWithFormat:@"%@",[[items objectAtIndex:indexPath.row] objectForKey:@"thr:total"]];
    cell.blogThr.text = comments;
    cell.blogCategory.text = [[items objectAtIndex:indexPath.row]objectForKey:@"itunes:keywords"];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    cell.blogSubTitle.text = [dateFormatter stringFromDate:[[items objectAtIndex:indexPath.row] objectForKey:@"pubDate"]];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return 148;
	}
    
    return 82;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        /* BlogIpadDetail *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailIpad"];
         itemDetail.item = [items objectAtIndex:indexPath.row];
         [self.navigationController pushViewController:itemDetail animated:YES];*/
    }
    
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        //[self performSegueWithIdentifier:@"detail" sender:self];
        // Show detail
        /*DetailController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
         itemDetail.item = [items objectAtIndex:indexPath.row];
         [self.navigationController pushViewController:itemDetail animated:YES];*/
        
    }
	
	// Deselect
	//[self.torahTableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"detail"]){
        
        JTNewsDetailViewController *itemDetail = (JTNewsDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.JTTableView indexPathForSelectedRow];
        itemDetail.item = [items objectAtIndex:indexPath.row];
        
        /*torahDetail* itemDetail = (torahDetail *)segue.destinationViewController;
        NSIndexPath * indexPath = [self.torahTableView indexPathForSelectedRow];
        itemDetail.item = [items objectAtIndex:indexPath.row];*/
        
        //[self.torahTableView deselectRowAtIndexPath:indexPath animated:YES];
        //[self.navigationController pushViewController:detail animated:YES];
        
    }
}

-(void) reloadTableData
{
    JTParser *rssParser = [[JTParser alloc] init];
    [rssParser parseRssFeed:NSLocalizedString(@"NEWS",nil) withDelegate:self];
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    if (items == nil) {
        
        [self performSelectorInBackground:@selector(loadData) withObject:nil];
        
        [self reloadTableData];
        self.JTTableView.userInteractionEnabled = YES;
        
    } else {
        [self.JTTableView reloadData];
    }
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading Jewish Times";
	
	[HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
    
    
}

#pragma mark -
#pragma mark Table view data source

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.JTTableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
    
    [self reloadTableData];
	self.JTTableView.userInteractionEnabled = YES;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading Jewish News";
	
	[HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            break;
        }
    }
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
	[formatter release];
	[itemsToDisplay release];
	[items release];
    [pull release];
    [HUD release];
    [_sView release];
    [super dealloc];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
}
@end
