//
//  NSInvocation+ZJAdd.m
//  CWZA
//
//  Created by 东岳 on 16/2/25.
//  Copyright © 2016年 北京中交兴路车联网科技有限公司. All rights reserved.
//

#import "NSInvocation+ZJAdd.h"

@implementation NSInvocation (ZJAdd)

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector
{
    return [[self class] invocationWithTarget:target selector:selector arguments:NULL];
}

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(void*)firstArgument,...
{
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:selector];
    if (!signature) {
        return nil;
    }
    NSInvocation *invoction = [NSInvocation invocationWithMethodSignature:signature];
    [invoction setTarget:target];
    [invoction setSelector:selector];
    
    if (firstArgument)
    {
        va_list arg_list;
        va_start(arg_list, firstArgument);
        [invoction setArgument:firstArgument atIndex:2];
        
        for (NSUInteger i = 2; i < signature.numberOfArguments; i++) {
            void *argument = va_arg(arg_list, void *);
            [invoction setArgument:argument atIndex:i];
        }
        va_end(arg_list);
    }
    
    return invoction;
}


@end
