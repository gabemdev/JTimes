//
//  JTBlogViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/8/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTBlogViewController.h"
#import "DocumentRoot.h"
#import "Element.h"
#import "JTParser.h"
#import "AFXMLRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "MBProgressHUD.h"
#import "JTAppDelegate.h"
#import "JTCell.h"
#import "JTNewsDetailViewController.h"
#import "JTBlogDetailViewController.h"

@class MBProgressHUD;

@interface JTBlogViewController (PrivateMethods)

-(void)loadData;

@end

@implementation JTBlogViewController

@synthesize items;
@synthesize sView = _sView;
@synthesize JTBlogTableView;

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
    self.title = @"Blog";
    
    [[LocalyticsSession shared] tagEvent:@"Blog News Main"];
    
    self.pullToRefreshView = [[GMDPTRView alloc] initWithScrollView:self.JTBlogTableView delegate:self];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading Jewish Blog";
	
	[HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
    
    NSURL *requestURL = [NSURL URLWithString:kCDKBlogUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest: request
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                                                                               XMLParser.delegate = self;
                                                                                               [XMLParser parse];
                                                                                           } failure:nil];
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc]init]autorelease];
    [queue addOperation:operation];
	
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
    [self.view setBackgroundColor:bgColor];
    
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
    
    [self.JTBlogTableView setDelegate:self];
    [self.JTBlogTableView setDataSource:self];
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
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(popTime, backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (items == nil) {
                JTParser *rssParser = [[JTParser alloc] init];
                [rssParser parseRssFeed:kCDKBlogUrl withDelegate:self];
                [self.JTBlogTableView reloadData];
            } else {
                [self.JTBlogTableView reloadData];
            }
        });
    });
}

- (void)receivedItems:(NSArray *)theItems {
    items = theItems;
    [self.JTBlogTableView reloadData];
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
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
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
        NSIndexPath *indexPath = [self.JTBlogTableView indexPathForSelectedRow];
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
    [rssParser parseRssFeed:kCDKBlogUrl withDelegate:self];
    [self.JTBlogTableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.JTBlogTableView.contentOffset = CGPointMake(0, -65);
    [self performSelectorInBackground:@selector(loadData) withObject:nil];
    
    [self reloadTableData];
	self.JTBlogTableView.userInteractionEnabled = YES;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading Jewish Blog";
	
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
    [HUD release];
    [_sView release];
    [super dealloc];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
}

#pragma mark - PTR
- (BOOL)pullToRefreshViewShouldStartLoading:(GMDPTRView *)view {
    return YES;
}

- (void)pullToRefreshViewDidStartLoading:(GMDPTRView *)view {
    [self refresh];
}

- (void)pullToRefreshViewDidFinishLoading:(GMDPTRView *)view {
    
}

- (void)refresh {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(popTime, backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pullToRefreshView finishLoading];
            [self reloadTableData];
            [self.JTBlogTableView reloadData];
        });
    });
}

@end
