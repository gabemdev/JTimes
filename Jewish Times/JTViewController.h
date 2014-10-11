//
//  JTViewController.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

//#import "GAITrackedViewController.h"


@interface JTViewController : UIViewController

- (void)trackEvent:(NSString *)event withValue:(NSNumber *)value;


- (void)disableSwipeNavigation;
- (void)enableSwipeNavigation;

@end
