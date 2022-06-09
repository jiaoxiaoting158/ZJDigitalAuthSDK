//
//  UIButton+Wrapper.m
//  UtilSummary
//
//  Created by Yangyanyan on 16/8/29.
//  Copyright © 2016年 Yangyanyan. All rights reserved.
//

#import "UIButton+Wrapper.h"

@implementation UIButton (Wrapper)
/**
 *  设置按钮的frame,title,titleColor
 *
 *  @return 获取按钮
 */
-(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    return button;
}
/**
 *  设置按钮的frame,title,titleColor,fontSize,action
 *
 *  @return 获取按钮
 */
-(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/**
 *  设置按钮的frame,title,titleColor,fontSize,normal状态下的image,hightLight状态下的image,action
 *
 *  @return 获取按钮
 */
-(UIButton *)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize normalImageNamed:(NSString *)normalImageNamed highlightedImageNamed:(NSString *)highlightedImageNamed action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [button setImage:[UIImage imageNamed:normalImageNamed] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageNamed] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



@end
