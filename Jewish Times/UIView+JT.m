//
//  UIView+JT.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "UIView+JT.h"

@implementation UIView (JT)

+ (id)loadFromXIB
{
    NSString *nibName = [NSString stringWithFormat:@"%@",[self class]];
    return [UIView loadFromXIB:nibName];
}

+ (id)loadFromXIB:(NSString *)nibName
{
    return [UIView loadFromXIB:nibName atIndex:NSNotFound];
}

+ (id)loadFromXIB:(NSString *)nibName atIndex:(NSUInteger)index
{
    if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        UIView *view;
        if (index < views.count) {
            view = views[index];
        } else {
            view = [views lastObject];
        }
        return view;
    }
    return nil;
}

@end
