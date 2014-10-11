//
//  JTUIService.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTUIService : NSObject

+ (JTUIService *)sharedInstance;

- (id)viewControllerWithStoryboardIdentifier:(NSString *)identifier;

@end
