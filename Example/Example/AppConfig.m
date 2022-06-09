//
//  PLConfig.m
//
//  Created by jiaoxt on 14-8-15.
//  Copyright (c) 2014年 jiaoxt. All rights reserved.
//

#import "AppConfig.h"
#import "HandleString.h"

@implementation AppConfig

+ (instancetype)share{
    static dispatch_once_t t;
    static AppConfig *service = nil;
    dispatch_once(&t, ^{
        service = [[AppConfig alloc] init];
    });
    
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getFromLocal];
    }
    return self;
}

- (BOOL)saveToLocal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *resultTicket = [HandleString handleNull:self.ticket];
    if (resultTicket.length != 0) {
        [userDefaults setObject:resultTicket forKey:@"ticket"];
    }
    
    NSString *resultAppUserId = [HandleString handleNull:self.appUserId];
    if (resultAppUserId.length != 0) {
        [userDefaults setObject:resultAppUserId forKey:@"appUserId"];
    }
    
    return [userDefaults synchronize];
}

- (void)getFromLocal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *resultTicket = [HandleString handleNull:[userDefaults objectForKey:@"ticket"]];
    if (resultTicket.length != 0 && self.ticket.length == 0) {
//        self.ticket = resultTicket;
    }
    
    
    NSString *resultAppUserId = [HandleString handleNull:[userDefaults objectForKey:@"appUserId"]];
    if (resultAppUserId.length != 0 && self.appUserId.length == 0) {
        self.appUserId = resultAppUserId;
    }

}

@end

