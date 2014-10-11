//
//  JTAnalytics.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTAnalytics : NSObject

+ (JTAnalytics *)sharedInstance;

- (void)trackEvent:(NSString *)event withValue:(NSNumber *)value fromSender:(NSString *)sender;

@end
