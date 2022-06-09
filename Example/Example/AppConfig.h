//
//  PLConfig.h
//  Test
//
//  Created by jiaoxt on 14-8-15.
//  Copyright (c) 2014年 jiaoxt. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - 访问地址



@interface AppConfig : NSObject

+ (instancetype _Nonnull )share;

@property (nonatomic,copy,nonnull)NSString *ticket;
@property (nonatomic,copy,nonnull)NSString *appUserId;


- (BOOL)saveToLocal;

@end

