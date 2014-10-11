//
//  JTMoreViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/9/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTMoreViewController.h"
#import "JTAppDelegate.h"
#import "JTCell.h"
#import "Twitter/Twitter.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Privacy.h"
#import "Terms.h"

@interface JTMoreViewController ()

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSDictionary *feedbackItems;

@end

@implementation JTMoreViewController

@synthesize feedbackTableView;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    [[LocalyticsSession shared] tagEvent:@"More Main"];
    
    self.title = @"More Info";
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
    [self.view setBackgroundColor:bgColor];
    
    [self.feedbackTableView setDelegate:self];
    [self.feedbackTableView setDataSource:self];
    
	NSArray *a3 = [[NSArray alloc]initWithObjects:@"Tweet about us...",@"Share us on Facebook...",@"Rate This App",nil];
	NSArray *a2 = [[NSArray alloc]initWithObjects:@"Facebook",@"Twitter",@"On the web",nil];
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"Send Feedback", nil];
	NSDictionary *temp =[[NSDictionary alloc]initWithObjectsAndKeys:a1,@"Send Feedback",a2,@"Kabbalah.info on",a3,@"Love Jewish Times? Help us grow:",nil];
	self.feedbackItems =temp;
    NSLog(@"table %@",self.feedbackItems);
	NSLog(@"table with Keys %@",[self.feedbackItems allKeys]);
	self.list =[self.feedbackItems allKeys];
    NSLog(@"sorted %@",self.list);
	// Do any additional setup after loading the view.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.list count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.list objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *listData =[self.feedbackItems objectForKey:[self.list objectAtIndex:section]];
	return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JTCell";
    
    NSArray *listData =[self.feedbackItems objectForKey:
                        [self.list objectAtIndex:[indexPath section]]];
    JTCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        
        cell = [[JTCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier];
        
		/*cell = [[[UITableViewCell alloc]
         initWithStyle:UITableViewCellStyleSubtitle
         reuseIdentifier:SimpleTableIdentifier] autorelease];
         */
	}
    
	NSUInteger row = [indexPath row];
	cell.blogTitle.text = [listData objectAtIndex:row];
    
    //cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds]autorelease];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return 72;
	}
    
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *listData =[self.feedbackItems objectForKey:
                        [self.list objectAtIndex:[indexPath section]]];
    NSUInteger row = [indexPath row];
	NSString *rowValue = [listData objectAtIndex:row];
	NSString *str = rowValue;
    
    if ([str isEqual:@"Send Feedback"])
	{
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"info@kabbalah.info", nil]];
            [composer setSubject:@"Jewish Times - Feedback"];
            [composer setMessageBody:@"" isHTML:YES];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [composer setModalPresentationStyle:UIModalPresentationFormSheet];
                
            }
            else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                
            }
            [self presentViewController:composer animated:YES completion:nil];
        }
        
        [[LocalyticsSession shared] tagEvent:@"Feedback Email"];
		
	}
    else if ([str isEqual:@"Facebook"])
	{
        NSURL* url = [NSURL URLWithString:@"https://m.facebook.com/kabbalahinfo"];
        [[UIApplication sharedApplication] openURL:url];
        [[LocalyticsSession shared] tagEvent:@"Facebook on the Web"];
        [[JTAnalytics sharedInstance] trackEvent:@"Experience Viewed" withValue:nil fromSender:@"Root"];
		
	}
    
    else if ([str isEqual:@"Twitter"])
	{
        NSURL* url = [NSURL URLWithString:@"https://mobile.twitter.com/kabbalahinfo"];
        [[UIApplication sharedApplication] openURL:url];
        [[LocalyticsSession shared] tagEvent:@"Facebook on the Web"];
		
	}
    else if ([str isEqual:@"On the web"])
	{
        NSURL* url = [NSURL URLWithString:@"http://www.kabbalah.info"];
        [[UIApplication sharedApplication] openURL:url];
        [[LocalyticsSession shared] tagEvent:@"Facebook on the Web"];
		
	}
    
    else if ([str isEqual:@"Tweet about us..."])
	{
        NSString *message = @"Check out the Jewish Times! via Jewish Times App";
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            
            [tweetSheet addURL:[NSURL URLWithString:@"http://www.kabbalah.info"]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        [[LocalyticsSession shared] tagEvent:@"Tweet"];
	}
    
    
    else if ([str isEqual:@"Share us on Facebook..."])
	{
        
        NSString *message = @"Check out the Jewish Times! via Jewish Times App";
        NSURL *url = [NSURL URLWithString:@"http://www.kabbalah.info"];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:message];
            [controller addURL:url];
            
            [self presentViewController:controller animated:YES completion:Nil];
		}
        [[LocalyticsSession shared] tagEvent:@"Facebook"];
	}
    
    else if ([str isEqual:@"Rate This App"])
	{
        NSURL *currenturl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/jtimes/id684063749?ls=1&mt=8"];
        [[UIApplication sharedApplication] openURL:currenturl];
        [[LocalyticsSession shared] tagEvent:@"App Store"];
        
        //http://itunes.apple.com/us/app/kabbalah-app/id550938690?ls=1&mt=8
		
	}
    
	[self.feedbackTableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Unable to send email" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(self) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:ACAccountStoreDidChangeNotification];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
