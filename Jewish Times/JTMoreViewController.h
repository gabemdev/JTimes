//
//  JTMoreViewController.h
//  Jewish Times
//
//  Created by Rockstar. on 8/9/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTMoreViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *feedbackTableView;

@end
