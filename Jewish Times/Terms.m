//
//  Terms.m
//  Torah Portion
//
//  Created by Rockstar. on 6/25/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "Terms.h"

@interface Terms ()

@end

@implementation Terms{
    
    UIBarButtonItem *_backBarButton;
    UIBarButtonItem *_actionButton;
    
}

@synthesize webView = _webView;
@synthesize activityIndicator;

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
    [[LocalyticsSession shared] tagEvent:@"Terms Main"];
    
    self.title = @"Terms of Service";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_nav_bar_dark_compose_dm"] landscapeImagePhone:[UIImage imageNamed:@"icn_nav_bar_dark_compose_dm"] style:UIBarButtonItemStyleBordered target:self action:@selector(openActionSheet:)];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tweet_place_holder~iphone.png"]];
    [self.view setBackgroundColor:bgColor];
    
    _backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] landscapeImagePhone:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
    
    _actionButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icn_nav_bar_dark_actions"]landscapeImagePhone:[UIImage imageNamed:@"icn_nav_bar_dark_actions"] style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects:
                         _backBarButton,
                         flexibleSpace,
                         [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)],
                         flexibleSpace,
                         _actionButton,
                         nil];
    
    for (UIBarButtonItem *button in self.toolbarItems){
        button.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    self.activityIndicator = indicator;
    [indicator release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: (0.5)
                                             target:self
                                           selector:@selector(loading)
                                           userInfo:Nil
                                            repeats:YES];
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
    
    NSString *fullURL = NSLocalizedString(@"TERMS_WEB", nil);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Private
-(void)loading {
    _backBarButton.enabled = [_webView canGoBack];
    
	UIBarButtonItem *reloadButton = nil;
    if (!_webView.loading) {
        
        [activityIndicator stopAnimating];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)];
        _actionButton.enabled = YES;
    }
    else {
        [activityIndicator startAnimating];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(stopLoading)];
    }
    reloadButton.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	
	NSMutableArray *items = [self.toolbarItems mutableCopy];
	[items replaceObjectAtIndex:2 withObject:reloadButton];
	self.toolbarItems = items;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    
    [super dealloc];
    [_webView release];
}

- (void) viewDidUnload{
    
    [super viewDidUnload];
    [_webView release];
}

@end
