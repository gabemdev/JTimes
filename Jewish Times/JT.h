//
//  JT.h
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JT : NSObject

typedef void (^JTBooleanBlock)(BOOL succeeded, NSError* error);
typedef void (^JTIntegerBlock)(int number, NSError* error);
typedef void (^JTArrayBlock)(NSArray* objects, NSError* error);
typedef void (^JTObjectBlock)(id object, NSError* error);
typedef void (^JTImageBlock)(UIImage* image, NSError* error);
typedef void (^JTRequestBlock)(NSData *data,NSURLResponse *response,NSError* error);
typedef void (^JTBlock)(void);

/**
 * Queues up the given block to be executed on the main thread.
 */
void JTDispatchOnMain(void (^block)());

/**
 * Queues up the given block to be executed on the CURRENT thread after at least n seconds.
 */
void JTDispatchAfter(float seconds, void (^block)());

/**
 * Queues up a calculation to run on a background thread.
 */
void JTDispatchBackground(void (^block)());

@end
