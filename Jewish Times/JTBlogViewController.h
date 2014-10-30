//
//  JTBlogViewController.h
//  Jewish Times
//
//  Created by Rockstar. on 8/8/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GMDPTR.h"

@interface JTBlogViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
    MBProgressHUD *HUD;
    
    long long expectedLength;
	long long currentLength;
	
	// Parsing
    NSArray *items;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    
    
    Reachability *internetReach;
    
//    IBOutlet UIImageView *postImage;
}

@property (nonatomic, strong) IBOutlet UITableView *JTBlogTableView;
@property (retain, nonatomic) NSArray *items;
@property (retain, nonatomic) IBOutlet UIImage *postImage;
@property (retain, nonatomic) IBOutlet UIImageView *sView;
@property (nonatomic, strong) GMDPTRView *pullToRefreshView;

@end
