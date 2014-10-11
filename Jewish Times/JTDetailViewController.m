//
//  JTDetailViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/5/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JTCollection.h"
#import "JTVideoViewController.h"
#import "MBProgressHUD.h"


@interface JTDetailViewController (){
    
    BOOL _isNavigatingBack;
}

- (void)backButtonTapped:(id)sender;

@end

@implementation JTDetailViewController
@synthesize viewButton;
@synthesize titleLabel = _titleLabel;
@synthesize detailText = _detailText;
@synthesize videoImage = _videoImage;
@synthesize urlString = _urlString;
@synthesize textString = _textString;

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
    [[LocalyticsSession shared] tagEvent:[self.schema valueForKey:@"title"]];
    
    //UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
    //[self.view setBackgroundColor:bgColor];
    
    //Set Scroller~iPhone
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 514)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_nav_bar_light_compose_dm"] landscapeImagePhone: [UIImage imageNamed:@"icn_nav_bar_light_compose_dm"] style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet:)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    
    //Back Button
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [back setImage:[UIImage imageNamed:@"back-arrow-darktheme"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
    
    //Play Video Button
    UIImage *btn = [UIImage imageNamed:@"btn_standard_default~ipad.png"];
    UIImage *stretchBtn = [btn stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnImageView = [[UIImageView alloc]initWithImage:stretchBtn];
    btnImageView.frame = CGRectMake(28, 402, 265.0, stretchBtn.size.height);
    [viewButton setBackgroundImage:stretchBtn forState:UIControlStateNormal];
    
    UIImage *btnPressed = [UIImage imageNamed:@"btn_standard_pressed~ipad.png"];
    UIImage *stretchBtnPressed = [btnPressed stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnPressedImageView = [[UIImageView alloc]initWithImage:stretchBtnPressed];
    btnPressedImageView.frame = CGRectMake(28, 402, 265.0, stretchBtnPressed.size.height);
    [viewButton setBackgroundImage:stretchBtnPressed forState:UIControlStateHighlighted];
    
    /*UIImage *video = [UIImage imageNamed:[self.schema valueForKey:@"videoBGImage"]];
    _videoImage = [[UIImageView alloc]initWithImage:video];
    _videoImage.frame = CGRectMake(20, 171, 280.0, 150.0);
    [self.view addSubview:_videoImage];*/
    
    UIImage *video = [UIImage imageNamed:[self.schema valueForKey:@"videoBGImage"]];
    CALayer * l = [self.videoImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:0.0];
    [self.videoImage setImage:video];
    
    [self.titleLabel setText:[self.schema valueForKey:@"title"]];
    [self.detailText setText:[self.schema valueForKey:@"detailText"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)viewVideo:(id)sender{
    
    [self performSegueWithIdentifier:@"video" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"video"]){
        
        NSString *fullURL = [self.schema valueForKey:@"url"];
        NSString *title = [self.schema valueForKey:@"title"];
        
        JTVideoViewController * vc = [segue destinationViewController];
        vc.webString = fullURL;
        vc.titleString = title;
    }
}

- (IBAction)openActionSheet:(id)sender{
    if ([UIActivityViewController class]) {
        
        NSString *textToShare = [NSString stringWithFormat:@"Check out %@ via @Jewish Times", [self.schema valueForKey:@"title"]];;
        NSURL *url = [NSURL URLWithString:[self.schema valueForKey:@"url"]];
        NSArray *itemsToShare = [[NSArray alloc] initWithObjects:textToShare, url, nil];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = [[NSArray alloc] initWithObjects: UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, nil];
        
        UIActivityViewControllerCompletionHandler completionBlock = ^(NSString *activityType, BOOL completed) {
            if (completed) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Done!";
                
                [hud show:YES];
                [hud hide:YES afterDelay:1];
            } else{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error-bubble.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Oops! Something went wrong!";
                
                [hud show:YES];
                [hud hide:YES afterDelay:1];
            }
            
        };
        activityVC.completionHandler = completionBlock;
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@""
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:
                                          NSLocalizedString(@"TWITTER", nil),
                                          NSLocalizedString(@"EMAIL", nil),
                                          NSLocalizedString(@"FACEBOOK",nil),
                                          NSLocalizedString(@"SAFARI",nil),
                                          
                                          nil];
            [actionSheet showInView:self.tabBarController.tabBar];
        }
    }
    
    
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


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // just set to nil
    actionSheet = nil;
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"Check out %@ via @Jewish Times App", [self.schema valueForKey:@"title"]];
        self.urlString = [self.schema valueForKey:@"url"];
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            
            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }
    
    if (buttonIndex == 1) {
        self.textString = [self.schema valueForKey:@"detailText"];
        
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
            [composer setSubject:@"Found this and thought of sharing it with you."];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>"];
            [body appendString:self.title];
            [body appendString:@"</h2>"];
            [body appendString:@"<p>"];
            [body appendString:self.textString];
            [body appendString:@"</p>"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/kabbalahinfo\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/kabbalahinfo\">Facebook</a></br>"];
            [body appendString:@"</p>"];
            
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id684063749\">Jewish Times</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:composer animated:YES completion:nil];
        }
        
    }
    
    if (buttonIndex == 2){
        NSString *message = [NSString stringWithFormat:@"Check out %@. | Via Kabbalah App.", [self.schema valueForKey:@"title"]];
        NSURL *url = [NSURL URLWithString:[self.schema valueForKey:@"url"]];

        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:message];
            [controller addURL:url];
            
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
    
    if (buttonIndex == 3){
        NSURL *currenturl = [NSURL URLWithString:[self.schema valueForKey:@"url"]];
        [[UIApplication sharedApplication] openURL:currenturl];
        
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
        [hud hide:YES afterDelay:1];
        
        
	}
    
    else if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

// UIAlertView helper for post buttons
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
