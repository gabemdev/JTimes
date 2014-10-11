//
//  JTRootTabBarController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTRootTabBarController.h"

@interface JTRootTabBarController ()

@end

@implementation JTRootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setSelectedIndex:0];
    
    UITabBarItem *jtimes = self.tabBar.items[0];
    [jtimes setFinishedSelectedImage:[UIImage imageNamed:@"11-clock"] withFinishedUnselectedImage:[UIImage imageNamed:@"11-clock"]];     
    
    UITabBarItem *news = self.tabBar.items[1];
    [news setFinishedSelectedImage:[UIImage imageNamed:@"166-newspaper"] withFinishedUnselectedImage:[UIImage imageNamed:@"166-newspaper"]];
    
    UITabBarItem *blog = self.tabBar.items[2];
    [blog setFinishedSelectedImage:[UIImage imageNamed:@"28-star"] withFinishedUnselectedImage:[UIImage imageNamed:@"28-star"]];
    
    UITabBarItem *more = self.tabBar.items[3];
    [more setFinishedSelectedImage:[UIImage imageNamed:@"60-signpost"] withFinishedUnselectedImage:[UIImage imageNamed:@"60-signpost"]];
    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:25/255.0 green:96/255.0 blue:148/255.0 alpha:1.0]];
    
}
/*
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
	[self _presentLoadingScreen];
}

- (void)_presentLoadingScreen
{
    UIViewController *loading = [[JTUIService sharedInstance] viewControllerWithStoryboardIdentifier:@"Loading View Controller"];
    [self presentViewController:loading animated:NO completion:nil];
}
*/
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.tabBar.selectedItem == item) {
        [[self selectedViewController] popAndScroll];
    }
}

@end
