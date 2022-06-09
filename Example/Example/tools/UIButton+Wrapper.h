//
//  UIButton+Wrapper.h
//  UtilSummary
//
//  Created by Yangyanyan on 16/8/29.
//  Copyright © 2016年 Yangyanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Wrapper)

/**
 *  设置按钮的frame,title,titleColor
 *
 *  @return 获取按钮
 */
-(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor;
/**
 *  设置按钮的frame,title,titleColor,fontSize,action
 *
 *  @return 获取按钮
 */

-(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize action:(SEL)action;
/**
 *  设置按钮的frame,title,titleColor,fontSize,normal状态下的image,hightLight状态下的image,action
 *
 *  @return 获取按钮
 */
-(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize normalImageNamed:(NSString *)normalImageNamed highlightedImageNamed:(NSString *)highlightedImageNamed action:(SEL)action;

@end
