//
//  NSInvocation+ZJAdd.h
//  CWZA
//
//  Created by 东岳 on 16/2/25.
//  Copyright © 2016年 北京中交兴路车联网科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (ZJAdd)

#pragma mark - Invocation
#pragma mark -

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector;

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(void*)firstArgument,...;

@end
