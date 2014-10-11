//
//  JTViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTViewController.h"
#import "JTAppDelegate.h"

@interface JTViewController (){
    
    BOOL _shouldUseSwipeNavigation;
}

@end

@implementation JTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _handleSwipe];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Tracking
- (void)trackEvent:(NSString *)event withValue:(NSNumber *)value{

}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    //self.trackedViewName = title;
}

#pragma mark - Swipe Navigation

- (void)disableSwipeNavigation
{
    _shouldUseSwipeNavigation = NO;
}

- (void)enableSwipeNavigation
{
    _shouldUseSwipeNavigation = YES;
}

- (void)_setupSwipeNavigation
{
    _shouldUseSwipeNavigation = YES;
    SEL _swipeSelector = @selector(_handleSwipe);
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:_swipeSelector];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipe];
}

- (void)_handleSwipe{
    
    if (_shouldUseSwipeNavigation) [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
