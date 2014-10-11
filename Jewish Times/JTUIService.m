//
//  JTUIService.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTUIService.h"

@implementation JTUIService

- (id)init
{
    
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)_initPrivate;
{
    
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //[self _setupTabBarAppearance];
        [self _setupNavBarAppearance];
        //[self _setupBarButtonAppearance];
        [self _setupToolBarAppearance];
    }
    
    return self;
}

- (void)_setupTabBarAppearance
{
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"Tabbar_Background"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@""]];
//    [[UITabBar appearance] setSelectedImageTintColor:<#(UIColor *)#>]
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:0.16f green:0.45f blue:0.73f alpha:1.0f]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0]}
                                             forState:UIControlStateSelected];
}

- (void)_setupNavBarAppearance
{
    
    //UINavigationBar *navigationBar = [UINavigationBar appearance];
	//[navigationBar setBackgroundImage:[UIImage imageNamed:@"Navbar_BG"] forBarMetrics:UIBarMetricsDefault];
	//[navigationBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
	/*[navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
										   [UIFont boldSystemFontOfSize:20.0f], UITextAttributeFont,
										   [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
										   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
										   [UIColor colorWithRed:0.16f green:0.45f blue:0.73f alpha:1.0f], UITextAttributeTextColor,
										   nil]];*/
	
	// Navigation bar mini
	//[navigationBar setTitleVerticalPositionAdjustment:-2.0f forBarMetrics:UIBarMetricsLandscapePhone];
	//[navigationBar setBackgroundImage:[UIImage imageNamed:@"Navbar_BG"] forBarMetrics:UIBarMetricsLandscapePhone];
}

- (void)_setupBarButtonAppearance
{
    
    // Navigation button
	/*NSDictionary *barButtonTitleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
												  [UIFont systemFontOfSize:14.0f], UITextAttributeFont,
                                                  [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f],
                                                  UITextAttributeTextColor,
												  [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
												  [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
												  nil];*/
	//UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
	//	[barButton setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsDefault];
	//[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
	//[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateHighlighted];
	//[barButton setBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Normal"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	//[barButton setBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Pressed"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	
	// Navigation back button
	//[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(2.0f, -2.0f) forBarMetrics:UIBarMetricsDefault];
	//[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Back_Normal"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	//[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Back_Pressed"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	
	// Navigation button mini
	//	[barButton setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsLandscapePhone];
	//[barButton setBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Normal"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
	//[barButton setBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Pressed"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
	
	// Navigation back button mini
	//[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(2.0f, -2.0f) forBarMetrics:UIBarMetricsLandscapePhone];
	//[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Back_Normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
	//[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Back_Pressed"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
    
    
}

- (void)_setupToolBarAppearance
{
    // Toolbar
	UIToolbar *toolbar = [UIToolbar appearance];
	[toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
	[toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	
	// Toolbar mini
	[toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background-mini"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsLandscapePhone];
	[toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background-mini"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsLandscapePhone];
}

- (id)viewControllerWithStoryboardIdentifier:(NSString *)identifier
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

+(JTUIService *)sharedInstance
{
    
    static JTUIService *instance = nil;
    if (!instance) {
        instance = [[JTUIService alloc] _initPrivate];
    }
    return instance;
}

@end
