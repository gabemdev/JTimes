//
//  JTLoadingImageView.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTLoadingImageView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)animateOffScreen:(JTBlock)block;

@end
