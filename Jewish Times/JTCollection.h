//
//  JTCollection.h
//  Jewish Times
//
//  Created by Rockstar. on 8/5/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JTCollection : NSObject

//Model for CollectionView
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * cellImage;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * detailText;
@property (nonatomic, strong) NSString * videoBGImage;
@property (nonatomic, strong) NSString * view;

@end
