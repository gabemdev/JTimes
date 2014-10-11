//
//  UIView+JT.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JT)

/**
 * Load view automatically from XIBs
 */
+ (id)loadFromXIB;
+ (id)loadFromXIB:(NSString *)nibName;
+ (id)loadFromXIB:(NSString *)nibName atIndex:(NSUInteger)index;

@end
