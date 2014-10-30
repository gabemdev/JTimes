//
//  JTBlogDetailViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/21/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTBlogDetailViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "JTAppDelegate.h"
#import "Twitter/Twitter.h"
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>

@interface JTBlogDetailViewController (){
    
    BOOL _isNavigatingBack;
}

- (void)backButtonTapped:(id)sender;

@end

@implementation JTBlogDetailViewController
{
    UIBarButtonItem *_backBarButton;
    UIBarButtonItem *_reloadBarButton;
    UIBarButtonItem *_shareBarButton;
}

@synthesize item, activityIndicator;
@synthesize imageString = _imageString;
@synthesize urlString = _urlString;
@synthesize itemSummary = _itemSummary;
@synthesize actionSheet_;
@synthesize bottomBar = _bottomBar;

- (id)initWithItem:(NSDictionary *)theItem {
	if (self = [super initWithNibName:@"Detail" bundle:nil]) {
		self.item = theItem;
		self.title = [item objectForKey:@"title"];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Back Button
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [back setImage:[UIImage imageNamed:@"back-arrow-darktheme"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
    [[LocalyticsSession shared] tagEvent:[item objectForKey:@"title"]];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
    [self.view setBackgroundColor:bgColor];
    
    _backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] landscapeImagePhone:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(goBack)];
    _backBarButton.tintColor = [UIColor grayColor];
    
    _reloadBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(reload)];
    _reloadBarButton.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects:
                         _backBarButton,
                         flexibleSpace,
                         _reloadBarButton,
                         flexibleSpace,
                         _shareBarButton,
                         nil];
    
    for (UIBarButtonItem *button in self.toolbarItems){
        button.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    self.activityIndicator = indicator;
    //[indicator release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = rightButton;
    //[rightButton release];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: (0.5)
                                             target:self
                                           selector:@selector(loading)
                                           userInfo:Nil
                                            repeats:YES];
    
	self.title = [item objectForKey:@"title"];
    _itemSummary.delegate = self;
    _itemSummary.scalesPageToFit = NO;
    
    NSString *titleHTML = [NSString stringWithFormat:@"<b>%@</b>", [item objectForKey:@"title"]];
    NSString *postHTML = [NSString stringWithFormat:@"<p>%@</p>", [item objectForKey:@"summary"]];
    //NSLog(@"%@",postHTML);
    
    NSString *structure =[NSString stringWithFormat:@"<html><head><meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=false' /><meta name='apple-mobile-web-app-capable' content='yes' /><link rel=\"stylesheet\" type=\"text/css\"href=\"combined.css\" ></style></head><body><section id='container'><section id='Blog'>"];
    
    NSString *close =[NSString stringWithFormat:@"</section></div></section></body></html>"];
    
    NSString *HTMLString = [NSString stringWithFormat:@"%@<h2>%@</h2><hr><article>%@<hr></article>%@", structure,titleHTML, postHTML, close];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [_itemSummary loadHTMLString:HTMLString baseURL:baseURL];
    
    internetReach = [Reachability reachabilityForInternetConnection];
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
            break;
        }
    }
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [super viewWillAppear:animated];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [super viewWillDisappear:animated];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

#pragma mark - Private
-(void)loading {
    /*_backBarButton.enabled = [_itemSummary canGoBack];
     
     _reloadBarButton = nil;
     if (!_itemSummary.loading) {
     
     [activityIndicator stopAnimating];
     _reloadBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(reload)];
     _reloadBarButton.tintColor = [UIColor grayColor];
     }
     else {
     [activityIndicator startAnimating];
     _reloadBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(stopLoading)];
     _reloadBarButton.tintColor = [UIColor grayColor];
     }
     _reloadBarButton.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
     
     NSMutableArray *items = [self.toolbarItems mutableCopy];
     [items replaceObjectAtIndex:2 withObject:_reloadBarButton];
     self.toolbarItems = items;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigateBack {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _isNavigatingBack = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _isNavigatingBack = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            _isNavigatingBack = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)backButtonTapped:(id)sender {
    [self navigateBack];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            break;
        }
    }
}

+(BOOL)isSocialFrameworkAvailable
{
    // whether the iOS6 Social framework is available?
    return NSClassFromString(@"SLComposeViewController") != nil;
}

- (IBAction)openActionSheet:(id)sender{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:
                                  NSLocalizedString(@"TWITTER", nil),
                                  NSLocalizedString(@"FACEBOOK", nil),
                                  NSLocalizedString(@"EMAIL",nil),
                                  nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    //[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // just set to nil
    actionSheet_ = nil;
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"Check out:%@. via Jewish Times App",[item objectForKey:@"title"]];
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            
            [tweetSheet addURL:[NSURL URLWithString:[item objectForKey:@"link"]]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
            tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        break;
                        case SLComposeViewControllerResultDone:
                        break;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:^{
                        NSLog(@"Tweetsheet dismissed");
                    }];
                });
            };
        }
        
    }
    if (buttonIndex == 1) {
        NSString *message = [NSString stringWithFormat:@"Check out: %@. Via Jewish Times App",[item objectForKey:@"title"]];
        NSURL *url = [NSURL URLWithString:[item objectForKey:@"link"]];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:message];
            [controller addURL:url];
            
            [self presentViewController:controller animated:YES completion:nil];
            
            controller.completionHandler = ^(SLComposeViewControllerResult result) {
                switch(result) {
                        //  This means the user cancelled without sending the Tweet
                    case SLComposeViewControllerResultCancelled:
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                        break;
                }
                
                //  dismiss the Tweet Sheet
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:^{
                        NSLog(@"FB has been dismissed.");
                    }];
                });
            };
        }
    }
    
    if (buttonIndex == 2) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
            [composer setSubject:self.title];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>"];
            [body appendString:self.title];
            [body appendString:@"</h2>"];
            [body appendString:@"<p>"];
            [body appendString:[item objectForKey:@"summary"]];
            [body appendString:@"</p>"];
            [body appendString:@"<a href =\""];
            [body appendString:[item objectForKey:@"link"]];
            [body appendString:@"\"> Link</a>\n"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/kabbalahinfo\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/kabbalahinfo\">Facebook</a></br>"];
            [body appendString:@"</p>"];
            
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id684063749\">Jewish Times App</a></p>\n"];
            //[composer setMessageBody:[item objectForKey:@"link"] isHTML:YES];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:composer animated:YES completion:nil];
        }
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        //HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Sent!";
        
        [hud show:YES];
        [hud hide:YES afterDelay:2];
        
        
	}
    
    else if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = [NSString stringWithFormat:@"There seems to be a problem. Please check the settings to make sure you are logged in."];
        alertTitle = @"Error";
    } else {
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.",
                    message];
        alertTitle = @"Success";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
