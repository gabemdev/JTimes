//
//  JT.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JT.h"

@implementation JT

void JTDispatchOnMain(void (^block)()) {
    dispatch_async(dispatch_get_main_queue(), block);
}

void JTDispatchAfter(float seconds, void (^block)()) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

void JTDispatchBackground(void (^block)()) {
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    dispatch_async(queue,block);
}

@end
