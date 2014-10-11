//
//  JTDataService.m
//  Jewish Times
//
//  Created by Rockstar. on 8/4/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "JTDataService.h"

@interface JTDataService ()
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation JTDataService

- (id)init
{
    
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)_initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"jtimes" ofType:@"plist"];
        self.data = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

- (id)dataForKey:(NSString *)key
{
    
    return [[self.data objectForKey:key] mutableCopy];
}

+ (JTDataService *)sharedInstance
{
    static JTDataService *instance = nil;
    if (!instance) {
        instance = [[JTDataService alloc] _initPrivate];
    }
    
    return instance;
}

@end
