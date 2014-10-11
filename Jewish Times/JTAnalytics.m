//
//  JTAnalytics.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTAnalytics.h"
#import <Crashlytics/Crashlytics.h>
#import "JTDefines.h"

@interface JTAnalytics ()
//@property (nonatomic, strong) id<GAITracker> gaiTracker;

@end

@implementation JTAnalytics

- (id)init
{
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)_initPrivate
{
    
    self = [super init];
    if (self) {
//        [GAI sharedInstance].trackUncaughtExceptions = YES;
//        [GAI sharedInstance].dispatchInterval = 10;
//        self.gaiTracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-2793234-8"];
        [[LocalyticsSession shared] startSession:kCDKLocalyticsKey];
        [Crashlytics startWithAPIKey:kCDKCrashlyticsKey];
    }
    
    return self;
}

- (void)trackEvent:(NSString *)event withValue:(NSNumber *)value fromSender:(NSString *)sender
{
    
//    [self.gaiTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"JTimes" action:event label:sender value:value]build]];
    
    
}

+ (JTAnalytics *)sharedInstance
{
    static JTAnalytics *instance = nil;
    if (!instance) {
        instance = [[JTAnalytics alloc] _initPrivate];

    }
    
    return instance;
}



@end
