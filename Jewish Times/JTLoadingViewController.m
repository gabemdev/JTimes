//
//  JTLoadingViewController.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTLoadingViewController.h"
#import "JTLoadingImageView.h"

@interface JTLoadingViewController ()
@property (nonatomic, weak) IBOutlet UIView *pictureContainerView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end

@implementation JTLoadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Loading";
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    JTDispatchAfter(0.5, ^{
        [self animatePictures:^{
            [self trackEvent:@"Loading Animation Complete" withValue:nil];
            [self.pictureContainerView removeFromSuperview];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    });
}

- (void)animatePictures:(JTBlock)completion
{
    [self _animatePictureAtIndex:0 completion:completion];
}

- (void)_animatePictureAtIndex:(NSUInteger)index completion:(JTBlock)block
{
    NSUInteger count = self.pictureContainerView.subviews.count;
    if (index < count) {
        JTLoadingImageView *view = self.pictureContainerView.subviews[index];
        if (index == count - 1) {
            [view animateOffScreen:^{
                JTDispatchAfter(0.5, block);
            }];
        } else {
            [view animateOffScreen:nil];
            JTDispatchAfter(0.1,^{
                [self _animatePictureAtIndex:index+1 completion:block];
            });
        }
    }
}

- (void)dealloc
{
    self.pictureContainerView = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.pictureContainerView = nil;
}

@end
