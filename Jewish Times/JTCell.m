//
//  JTCell.m
//  Jewish Times
//
//  Created by Rockstar. on 8/7/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTCell.h"

@implementation JTCell
@synthesize blogTitle;
@synthesize blogSubTitle;
@synthesize blogThr, blogCategory;
@synthesize blogImageView, blogCellBackground, blogImagePlaceholder;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected)
    {
        UIImage* bg = [UIImage imageNamed:@"ipad-list-item-selected.png"];
        
        [blogCellBackground setImage:bg];
        
        //[UIFont fontWithName:@"AbadiMTCondensedExtraBold.ttf" size: 13.0];
        //[blogTitle setFont:[UIFont fontWithName:@"AbadiMTCondensedExtraBold" size:8.0]];
        [blogTitle setTextColor:[UIColor blackColor]];
        [blogTitle setShadowColor:[UIColor whiteColor]];
        [blogTitle setShadowOffset:CGSizeMake(0, 0)];
        
        
        [blogSubTitle setTextColor:[UIColor whiteColor]];
        [blogSubTitle setShadowColor:[UIColor colorWithRed:25.0/255 green:96.0/255 blue:148.0/255 alpha:1.0]];
        [blogSubTitle setShadowOffset:CGSizeMake(0, 0)];
        
        [blogThr setTextColor:[UIColor whiteColor]];
        [blogThr setShadowColor:[UIColor colorWithRed:25.0/255 green:96.0/255 blue:148.0/255 alpha:1.0]];
        [blogThr setShadowOffset:CGSizeMake(0, 0)];
        
        [blogCategory setTextColor:[UIColor whiteColor]];
        [blogCategory setShadowColor:[UIColor colorWithRed:153.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        [blogCategory setShadowOffset:CGSizeMake(0, 0)];
        
    }
    else
    {
        UIImage* bg = [UIImage imageNamed:@"ipad-list-element.png"];
        
        [blogCellBackground setImage:bg];
        
        //[blogTitle setFont:[UIFont fontWithName:@"AbadiMTCondensedExtraBold" size:8.0]];
        [blogTitle setTextColor:[UIColor colorWithRed:42.0/255.0 green:115.0/255.0 blue:187.0/255.0 alpha:1.0]];
        [blogTitle setShadowColor:[UIColor darkGrayColor]];
        [blogTitle setShadowOffset:CGSizeMake(0, 0)];
        
        
        [blogSubTitle setTextColor:[UIColor colorWithRed:113.0/255 green:133.0/255 blue:148.0/255 alpha:1.0]];
        [blogSubTitle setShadowColor:[UIColor whiteColor]];
        [blogSubTitle setShadowOffset:CGSizeMake(0, 0)];
        
        [blogThr setTextColor:[UIColor colorWithRed:113.0/255 green:133.0/255 blue:148.0/255 alpha:1.0]];
        [blogThr setShadowColor:[UIColor clearColor]];
        [blogThr setShadowOffset:CGSizeMake(0, 0)];
        
        [blogCategory setTextColor:[UIColor colorWithRed:153.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        [blogCategory setShadowColor:[UIColor whiteColor]];
        [blogCategory setShadowOffset:CGSizeMake(0, 0)];
        
    }
    
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(7,10,80,65);
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
    
    
}

@end
