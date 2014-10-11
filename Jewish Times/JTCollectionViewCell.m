//
//  JTCollectionViewCell.m
//  Jewish Times
//
//  Created by Rockstar. on 8/5/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTCollectionViewCell.h"

@implementation JTCollectionViewCell
@synthesize title, image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
