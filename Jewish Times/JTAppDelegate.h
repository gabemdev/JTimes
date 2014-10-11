//
//  JTAppDelegate.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UIActionSheetDelegate>
{
    
    UIBackgroundTaskIdentifier bgTask; 
}

@property (strong, nonatomic) UIWindow *window;

@end
