//
//  ViewController.h
//  UserCenterDemo
//
//  Created by jiaoxt on 2019/5/6.
//  Copyright © 2019 jiaoxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#ifdef DEBUG
    #define ZJAuthAppID         @"1feeef9c5d894ba483120b7585a9cb08"
    #define ZJAuthAppSecret     @"7ee98b84a1cd46eaaac9b840002f2807"

//    #define ZJAuthAppID         @"03bf0b7661804d40b4ad84a27bb68ee6"
//    #define ZJAuthAppSecret     @"7e485a152a0c4eeebcd91e666f249bb3"

/// 线上
//#define ZJAuthAppID         @"bdc933416b30432e8609a35f05c30d64"
//#define ZJAuthAppSecret     @"6e0df7bb95a541308acff66de542c04e"

#else
    #define ZJAuthAppID         @"bdc933416b30432e8609a35f05c30d64"
    #define ZJAuthAppSecret     @"6e0df7bb95a541308acff66de542c04e"
#endif


@interface ViewController : UIViewController


@end
