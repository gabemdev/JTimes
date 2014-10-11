//
//  UIViewController+JT.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "UIViewController+JT.h"

@implementation UIViewController (JT)

- (void)popAndScroll
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self;
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:YES];
        } else if (nav.viewControllers.count == 1) {
            UIViewController *rootVC = nav.viewControllers[0];
            [rootVC popAndScroll];
        }
        return;
    }
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *s = (UIScrollView *)self.view;
        if (s.scrollsToTop && s.scrollEnabled) {
            [s setContentOffset:CGPointZero animated:YES];
        }
        return;
    }
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *s = (UIScrollView *)view;
            if (s.scrollsToTop && s.scrollEnabled) {
                [s setContentOffset:CGPointZero animated:YES];
            }
        }
    }
}

@end
