//
//  JTDefines.h
//  Jewish Times
//
//  Created by Rockstar. on 8/7/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef JTDEFINES
#define JTDEFINES (!DEBUG && !TARGET_IPHONE_SIMULATOR)

// Always use development on the simulator
#if !TARGET_IPHONE_SIMULATOR
#define BB_PRODUCTION_MODE 1
#endif


#define kCDKLocalyticsKey   @"16131c039a60b6b2868a413-897fb648-ff91-11e2-1143-004a77f8b47f"
#define kCDKCrashlyticsKey  @"62ce332ae1de018bdee39900e29eab6ab5d39419"
#define kCDKNewsUrl         @"http://feeds.feedburner.com/laitmancomcrisis"
#define kCDKBlogUrl         @"http://feeds.feedburner.com/KabbalahBlog"
#define kCDFNSDate          @"E, d LLL yyyy HH:mm:ss zzz"

#pragma mark - API

extern NSString *const kBBAPIScheme;
extern NSString *const kBBAPIHost;
extern NSString *const kBBPusherAPIKey;

extern NSString *const kBBDevelopmentAPIScheme;
extern NSString *const kBBDevelopmentAPIHost;
extern NSString *const kBBDevelopmentPusherAPIKey;


#pragma mark - User Defaults Keys

extern NSString *const kBBCurrentUserIDKey;
extern NSString *const kBBCurrentUsernameKey;
//extern NSString *const kCDKLocalyticsKey;
//extern NSString *const kCDKCrashlyticsKey;


#pragma mark - Misc

extern NSString *const kBBKeychainServiceName;

#pragma mark - Notifications

extern NSString *const kBBListDidUpdateNotificationName;
extern NSString *const kBBPlusDidChangeNotificationName;
extern NSString *const kBBUserUpdatedNotificationName;

#endif