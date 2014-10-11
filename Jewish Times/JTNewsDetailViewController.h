//
//  JTNewsDetailViewController.h
//  Jewish Times
//
//  Created by Rockstar. on 8/7/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTParser.h"
#import <FacebookSDK/FacebookSDK.h>

@interface JTNewsDetailViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
    NSDictionary *item;
    IBOutlet UIWebView *itemSummary;
    UIActivityIndicatorView *activityIndicator;
    UIActionSheet* actionSheet_;
    Reachability *internetReach;
    UIToolbar *bottomBar;
    
}

@property (retain, nonatomic) NSDictionary *item;
@property (retain, nonatomic) IBOutlet UIWebView *itemSummary;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIActionSheet *actionSheet_;
@property (nonatomic, strong) UIToolbar *bottomBar;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

- (id)initWithItem:(NSDictionary *)theItem;

//- (void)openActionSheet:(id)sender;

- (IBAction)openActionSheet:(id)sender;

+(BOOL)isSocialFrameworkAvailable;

@end

NSTimer *timer;