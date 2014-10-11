//
//  JTVideoViewController.h
//  Jewish Times
//
//  Created by Rockstar. on 8/6/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTViewController.h"
#import "JTCollection.h"
#import "JTDetailViewController.h"
#import "JTCollectionViewController.h"

@class Reachability;

@interface JTVideoViewController : JTViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    Reachability *internetReach;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *webString;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, strong) JTCollection *schema;

@end

NSTimer *timer;