//
//  ViewController.m
//  UserCenterDemo
//
//  Created by jiaoxt on 2019/5/6.
//  Copyright © 2019 jiaoxt. All rights reserved.
//

#import "ViewController.h"

#import "UIButton+Wrapper.h"
#import <AFNetworking/AFNetworking.h>
#import "NSInvocation+ZJAdd.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Toast/Toast.h>
#import "NSDictionary+YYAdd.h"

#import <AuthenticationServices/AuthenticationServices.h>

#import <ZJDigitalAuthSDK/ZJDigitalAuthSDK.h>
#import "AppConfig.h"
#import "HandleString.h"
#import "NSInvocation+ZJAdd.h"
#import <WXApi.h>
#import <YYKit/YYKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf) __strong __typeof(weakSelf) strongSelf = weakSelf;

#define USER_CENTER_TOKEN_KEY   @"USER_CENTER_TOKEN_KEY"
#define USER_CENTER_TICKET_KEY   @"USER_CENTER_TICKET_KEY"


#ifdef DEBUG
#define SmallProgramId          @"gh_5fff7a580049"
#define SmallProgramPath        @"/pages/index/index"
#define SmallProgramType        1
//#define SmallProgramType        0

#else
#define SmallProgramId          @"gh_5fff7a580049"
#define SmallProgramPath        @"/pages/index/index"
#define SmallProgramType        0
#endif

@interface ViewController ()

@property (nonatomic,strong)NSMutableArray *bottomButtons;
@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,copy)NSString *vno;
@property (nonatomic,copy)NSString *appUserId;

@property (nonatomic,copy)NSString *preUserId;

@end

@implementation ViewController

- (id)init{
    self = [super init];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *preId = [[NSUserDefaults standardUserDefaults] objectForKey:@"preUserId"];
    if (preId && [preId isKindOfClass:[NSString class]]) {
        self.preUserId = preId;
    }
    
    self.appUserId = [AppConfig share].appUserId;
    
    
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor blackColor];
    [self setupSubViews];
    
    WS(weakSelf);
    [ZJDigitalAuthSDK setWXSmallProgramShareInfoResultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *resultDic = resultData[@"result"];
            [weakSelf lauchWeiXinMiniProgram:resultDic];
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarColor:RGBCOLOR(0xf5, 0xf5, 0xf5)];
}


#pragma mark -
-(void)setNavigationBarColor:(UIColor *)imageColor{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBarTintColor:imageColor];
        [self.navigationController.navigationBar setTintColor:imageColor];
        [self.navigationController.navigationBar setBackgroundColor:imageColor];
    }
}

#pragma mark -

- (NSMutableArray *)bottomButtons{
    if (!_bottomButtons) {
        _bottomButtons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _bottomButtons;
}

- (void)setupSubViews{
    [self addButtons];
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, WIDTH - 20, HEIGHT - 50)];
    _infoLabel.numberOfLines = 20;
    _infoLabel.text = @"";
    [self.view addSubview:_infoLabel];
}

- (void)addButtons{
    
    for (UIButton *btn in self.bottomButtons) {
        [btn removeFromSuperview];
    }
    [self.bottomButtons removeAllObjects];
    
    
    
    [self addTuttonWithTitle:@"实名认证" action:@selector(realNameAuthButtonClick:) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"车主认证" action:@selector(perOwerAuthButtonClick:) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"查询授权信息" action:@selector(queryButtonClick:) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"重新初始化SDK" action:@selector(reInit) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"验证appUserId有效性" action:@selector(validAppUserIdButtonClick:) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"获取前置用户ID" action:@selector(fetchPreUserId:) inArray:self.bottomButtons];
//    [self addTuttonWithTitle:@"前置用户是否在有效期" action:@selector(validatePreUserId:) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"同意隐私协议" action:@selector(appUserAgreeProtocol:) inArray:self.bottomButtons];
    [self addTuttonWithTitle:@"同意两份协议" action:@selector(preUserAgreetwoProtocol:) inArray:self.bottomButtons];
    [self setButtonsFrame:self.bottomButtons firstX:20 firstY:100];
}

- (void)setButtonsFrame:(NSMutableArray *)buttonsArray
                 firstX:(CGFloat)firstX
                 firstY:(CGFloat)firstY
{
    if (!buttonsArray) {
        return;
    }
    
    for (int i = 0; i < buttonsArray .count; i++) {
        UIButton *btn = buttonsArray [i];
        CGRect rect = btn.frame;
        if (i == 0) {
            rect.origin.y = firstY;
            rect.origin.x = firstX;
        }
        else{
            UIButton *lastButton = buttonsArray[i-1];
            if (i % 2 ==0) {
                rect.origin.y = lastButton.frame.origin.y + lastButton.frame.size.height + 13;
                rect.origin.x = 20;
            }
            else{
                rect.origin.y = lastButton.frame.origin.y;
                rect.origin.x = self.view.frame.size.width - 20 - rect.size.width;
            }
        }
        
        [btn setFrame:rect];
    }
}




- (void)addTuttonWithTitle:(NSString *)buttonTitle action:(SEL)action inArray:(NSMutableArray *)buttonsArray{
    UIColor *buttonBackgroundColor = RGBCOLOR(0xd5, 0xd9, 0xd8);
    
    CGFloat buttonWidth = MIN((WIDTH - 60) / 2, 150);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100 + 64,buttonWidth , 40)
                                                 title:buttonTitle titleColor:RGBCOLOR(0x12, 0x12, 0x12)
                                              fontSize:13 normalImageNamed:nil
                                 highlightedImageNamed:nil action:action];
    button.layer.cornerRadius = 2.0;
    [button.layer setMasksToBounds:YES];
    button.backgroundColor = buttonBackgroundColor;
    [buttonsArray addObject:button];
    [self.view addSubview:button];
}

#pragma mark - 查询车辆授权信息
- (void)queryButtonClick:(UIButton *)btn{
    
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:@selector(test)];
    [self inputVehicleNo:invocation];
}

- (void)test{
    NSString *ticket = [HandleString handleNull:[AppConfig share].ticket];
    if (ticket.length == 0) {
        [self.view makeToast:@"sdk未完成初始化" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *appUserId = [HandleString handleNull:[AppConfig share].appUserId];
    //    if (appUserId.length == 0) {
    //        [self.view makeToast:@"未完成实名认证" duration:2.0 position:CSToastPositionCenter];
    //        return;
    //    }
    
    WS(weakSelf);
    [ZJDigitalAuthSDK queryVehicleAuthInfo:appUserId vno:self.vno resultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *resultDict = [resultData objectForKey:@"result"];
            NSString *accessToken = resultDict[@"accessToken"];
            NSString *ttl = resultDict[@"ttl"];
            
            NSString *info = [NSString stringWithFormat:@"车牌号：%@\n授权token：%@\n\n剩余时间：%@秒",weakSelf.vno,accessToken,ttl];
            weakSelf.infoLabel.text = info;
        }
        else{
            weakSelf.infoLabel.text = @"车辆授权失败";
            NSLog(@"车辆授权失败");
        }
    }];
}

- (void)inputVehicleNo:(NSInvocation *)invocation{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入车牌号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入车牌号";
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];

    
    WS(weakSelf);
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *vno = alertController.textFields[0].text;
        if (vno.length == 0 ) {
            [weakSelf.view makeToast:@"请输入车牌号" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(inputVehicleNo:) withObject:nil afterDelay:1.0];
            return;
        }
        if (![weakSelf validateAutoNo:vno]) {
            [weakSelf.view makeToast:@"请输入正确的车牌号" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(inputVehicleNo:) withObject:nil afterDelay:1.0];
            return;
        }
        
        weakSelf.vno = vno;
        if (invocation) {
            [invocation invoke];
        }
    }])];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

#pragma mark - 重新实始化
- (void)reInit{
    WS(weakSelf);
    [ZJDigitalAuthSDK initWithAppId:ZJAuthAppID
                          appSecret:ZJAuthAppSecret
                         completion:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        if (error == nil) {
            
            NSDictionary *resultDic = resultData[@"result"];
            NSString *ticket = resultDic[@"ticket"];
            [AppConfig share].ticket = ticket;
            [[AppConfig share] saveToLocal];
            NSLog(@"ZJDigitalAuthSDK 初始化成功");
            [weakSelf.view makeToast:@"初始化成功" duration:1.0 position:CSToastPositionCenter];
        }
        else{
            NSLog(@"ZJDigitalAuthSDK 初始化失败");
            [weakSelf.view makeToast:@"初始化失败" duration:1.0 position:CSToastPositionCenter];
        }
    }];
}


#pragma mark - 验证appUserId
- (void)validAppUserIdButtonClick:(id)sender{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:@selector(validAppUserId)];
    [self inputAppUserId:invocation];
}

- (void)inputAppUserId:(NSInvocation *)invocation{
    
    self.appUserId = [AppConfig share].appUserId;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入appUserId" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入appUserId";
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.text = weakSelf.appUserId;
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *appUserId = alertController.textFields[0].text;
        if (appUserId.length == 0 ) {
            [weakSelf.view makeToast:@"请输入appUserId" duration:1.0 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(inputAppUserId:) withObject:nil afterDelay:1.0];
            return;
        }
        
        
        weakSelf.appUserId = appUserId;
        if (invocation) {
            [invocation invoke];
        }
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)validAppUserId{
    
    [ZJDigitalAuthSDK validAppUserId:self.appUserId
                      resultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error)
     {
        NSUInteger statusCode = [[resultData objectForKey:@"status"] integerValue];
        NSString *status = resultData[@"status"];
        NSString *message = resultData[@"message"];
        if (statusCode == 1001) {
            message = resultData[@"result"][@"desc"];
        }
        
        NSString *result = [NSString stringWithFormat:@"appUserId:%@\nmessage:%@\n status:%@",self.appUserId,message,status];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证结果"
                                                                                 message:result
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }])];
        
        [self presentViewController:alertController animated:YES completion:^{}];
        
    }];
}

#pragma mark - 实名认证
- (void)realNameAuthButtonClick:(UIButton *)btn{
    NSString *ticket = [HandleString handleNull:[AppConfig share].ticket];
    if (ticket.length == 0) {
        [self.view makeToast:@"sdk未完成初始化" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    [ZJDigitalAuthSDK setRealNameAuthResultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *resultDict = [resultData objectForKey:@"result"];
            NSString *appUserId = resultDict[@"appUserId"];
            [AppConfig share].appUserId = appUserId;
            self.appUserId = appUserId;
            [[AppConfig share] saveToLocal];
            
        }
        else{
            
        }
    }];
    
    [ZJDigitalAuthSDK startRealNameAuthWithTicket:ticket
                                 currentContrller:self];
    
}

#pragma mark - 车主认证
- (void)perOwerAuthButtonClick:(UIButton *)btn
{
    NSString *ticket = [HandleString handleNull:[AppConfig share].ticket];
    if (ticket.length == 0) {
        [self.view makeToast:@"sdk未初始完成" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    NSString *appUserId = [HandleString handleNull:[AppConfig share].appUserId];
    //    if (appUserId.length == 0) {
    //        [self.view makeToast:@"未完成实名认证" duration:2.0 position:CSToastPositionCenter];
    //        return;
    //    }
    
    WS(weakSelf);
    [ZJDigitalAuthSDK setVehicleAuthResultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        if (!error) {
            NSArray *resultArray = [resultData objectForKey:@"result"];
            BOOL isHaveFailData = NO;
            NSMutableArray *failDataArray = [[NSMutableArray alloc] init];
            for (NSDictionary *data in resultArray) {
                
                if (![[data[@"status"] stringValue] isEqualToString:@"1001"]) {
                    isHaveFailData = YES;
                    [failDataArray addObject:data];
                }
            }
            
            if (!isHaveFailData) {
                
                weakSelf.infoLabel.text = @"车辆授权成功";
            }else {
                
                NSMutableString *info = [[NSMutableString alloc] initWithString:@"授权失败车辆\n"];
                for (NSDictionary *failData in failDataArray) {
                    NSString *vno = failData[@"vno"];
                    NSString *accessToken = failData[@"accessToken"];
                    NSString *infoStr = [NSString stringWithFormat:@"车牌号：%@,授权token：%@\n",vno,accessToken];
                    [info appendString:infoStr];
                }
                
                weakSelf.infoLabel.text = info;
            }
        }
        else{
            weakSelf.infoLabel.text = @"车辆授权失败";
            NSLog(@"车辆授权失败");
        }
    }];
    
    [ZJDigitalAuthSDK setRealNameAuthResultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *resultDict = [resultData objectForKey:@"result"];
            NSString *appUserId = resultDict[@"appUserId"];
            [AppConfig share].appUserId = appUserId;
            [[AppConfig share] saveToLocal];
            
        }
        
    }];
    [ZJDigitalAuthSDK startVehicleOwerAuthWithTicket:ticket  appUserId:appUserId currentContrller:self];
    
}

/// 获取用户的前端id
-(void)fetchPreUserId:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"信息输入" message:@"输入以下字段，得到前置用户id" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入真实姓名";
        textField.text = @"焦晓亭";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入身份证号";
        textField.text = @"130429198504054011";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"手机号";
        textField.text = @"18618293853";
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    
    WS(weakSelf);
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = alertController.textFields[0].text;
        if (name.length == 0 ) {
            [weakSelf.view makeToast:@"输入真实姓名" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(fetchPreUserId:) withObject:nil afterDelay:1.0];
            return;
        }
        
        NSString *idNo = alertController.textFields[1].text;
        if (idNo.length == 0 ) {
            [weakSelf.view makeToast:@"输入身份证号" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(fetchPreUserId:) withObject:nil afterDelay:1.0];
            return;
        }
        
        NSString *phoneNum = alertController.textFields[2].text;
        if (phoneNum.length == 0 ) {
            [weakSelf.view makeToast:@"手机号" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(fetchPreUserId:) withObject:nil afterDelay:1.0];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        NSDate *currentDate = [NSDate date];
        NSDate *resultDate = [currentDate dateByAddingMonths:6];
        NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[resultDate timeIntervalSince1970]];
        
        
        [ZJDigitalAuthSDK registerPreUserWithName:name
                                           idCard:idNo
                                            phone:phoneNum
                                       authResult:@"1"
                                         authTime:timestamp
                                   resultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error)
         {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSString *message = resultData[@"message"];
            if (!error) {
                NSDictionary *resultDic = [resultData objectForKey:@"result"];
                NSUInteger statusCode = [[resultData objectForKey:@"status"] integerValue];
                if (statusCode == 1001) {
                    NSString *preUserId = resultDic[@"preUserId"];
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"前置用户id:%@",preUserId];
                    weakSelf.preUserId = preUserId;
                    [[NSUserDefaults standardUserDefaults] setObject:preUserId forKey:@"preUserId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                    [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
                }
            }
            else{
                weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
            }
        }];
        
        
    }])];
    
 
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

/*
/// 验证用户UserId
-(void)validatePreUserId:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入前置用户id" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入前置用户id";
        textField.text = weakSelf.preUserId;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *preUserId = alertController.textFields[0].text;
        if (preUserId.length == 0 ) {
            [weakSelf.view makeToast:@"输入前置用户Id" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(validatePreUserId:) withObject:nil afterDelay:1.0];
            return;
        }
        
      
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [ZJDigitalAuthSDK  queryPerUserAgreementStatus:preUserId
                                        resultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error)
         {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSString *message = resultData[@"message"];
            if (!error) {
                NSDictionary *resultDic = [resultData objectForKey:@"result"];
                NSString *authBookResult = resultDic[@"authBookResult"];
                NSUInteger statusCode = [[resultData objectForKey:@"status"] integerValue];
                if (statusCode == 1001) {
                    NSString *des = @"已同意过隐私协议";
                    if ([authBookResult intValue] != 1) {
                    
                        des = @"未同意过隐私协议";
                    }
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"前置用户id:%@ \n%@",preUserId,des];
                }
                else{
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                    [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
                }
            }
            else{
                weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
            }
        }];
        
        
    }])];
    
  
    [self presentViewController:alertController animated:YES completion:^{}];
}*/

/// 同意隐私协议
-(void)appUserAgreeProtocol:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入appUserId，重新同意隐私协议" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入appUserId";
        textField.text = weakSelf.appUserId;
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *preUserId = alertController.textFields[0].text;
        if (preUserId.length == 0 ) {
            [weakSelf.view makeToast:@"输入appUserId" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(appUserAgreeProtocol:) withObject:nil afterDelay:1.0];
            return;
        }
        
        [ZJDigitalAuthSDK openAgreementPage:preUserId currentContrller:weakSelf resultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error) {
            
            NSString *message = resultData[@"message"];
            if (!error) {
                NSDictionary *resultDic = [resultData objectForKey:@"result"];
                NSString *resultType = resultDic[@"resultType"];
                NSUInteger statusCode = [[resultData objectForKey:@"status"] integerValue];
                if (statusCode == 1001) {
                    NSString *des = @"同意协议成功";
                    if ([resultType intValue] != 1) {
                        des = @"同意协议失败";
                    }
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"前置用户id:%@ \n%@",preUserId,des];
                }
                else{
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                    [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
                }
            }
            else{
                weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
            }
            
        }];
        
    }])];
    

    [self presentViewController:alertController animated:YES completion:^{}];
}


- (void)preUserAgreetwoProtocol:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入前置用户id" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder= @"输入前置用户id";
        textField.text = weakSelf.preUserId;
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *preUserId = alertController.textFields[0].text;
        if (preUserId.length == 0 ) {
            [weakSelf.view makeToast:@"输入前置用户Id" duration:1.5 position:CSToastPositionCenter];
            [weakSelf performSelector:@selector(preUserAgreetwoProtocol:) withObject:nil afterDelay:1.0];
            return;
        }
        
        [ZJDigitalAuthSDK openTwoAgreementsPage:preUserId
                               currentContrller:weakSelf
                                 resultCallBack:^(NSDictionary * _Nullable resultData, NSError * _Nullable error)
         {
            
            NSString *message = resultData[@"message"];
            if (!error) {
                NSDictionary *resultDic = [resultData objectForKey:@"result"];
                NSString *resultType = resultDic[@"resultType"];
                NSUInteger statusCode = [[resultData objectForKey:@"status"] integerValue];
                if (statusCode == 1001) {
                    NSString *des = @"同意协议成功";
                    if ([resultType intValue] != 1) {
                        des = @"同意协议失败";
                    }
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"前置用户id:%@ \n%@",preUserId,des];
                }
                else{
                    weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                    [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
                }
            }
            else{
                weakSelf.infoLabel.text = [NSString stringWithFormat:@"服务端返回信息:%@",message];
                [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",message]];
            }
            
        }];
        
    }])];
    

    [self presentViewController:alertController animated:YES completion:^{}];
}



-(UIViewController *) topMostController {
    return self;
}
#pragma mark -
- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    if (_hud.superview != self.view) {
        [self.view addSubview:_hud];
    }
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //设置等待框背景色为黑色
    
    _hud.bezelView.backgroundColor = [UIColor blackColor];
    
    _hud.removeFromSuperViewOnHide = YES;
    
    //设置菊花框为白色
    _hud.label.textColor = [UIColor whiteColor];
    _hud.label.font = [UIFont systemFontOfSize:15];
    
    return _hud;
}

#pragma mark - 验证车牌号
- (BOOL)validateAutoNo:(NSString *)autoNo
{
    NSString *autoRegex = @"^(([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z](([0-9]{5}[DF])|([DF]([A-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳使领]))$";
    NSPredicate *autoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",autoRegex];
    return [autoTest evaluateWithObject:autoNo];
}


#pragma mark - 跳转微信小程序


- (void)lauchWeiXinMiniProgram:(NSDictionary *)params{
    
    if (![WXApi isWXAppInstalled]) {
        [self.view makeToast:@"未安装微信" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    @try {
        NSString *userName = SmallProgramId;
        NSString *entData = [params objectForKey:@"entData"];
        NSString *path = [NSString stringWithFormat:@"%@?entData=%@",SmallProgramPath,entData];
        
        
        WXMiniProgramObject *object = [WXMiniProgramObject object];
        object.webpageUrl = @"http://www.qq.com";
        object.userName = userName;   // 小程序的userName
        object.path = path;     // 小程序的页面路径
        object.miniProgramType = SmallProgramType;  // 小程序的类型，默认正式版
        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"180.png"]);
        object.hdImageData = data;
        //        object.disableForward = YES;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"数字化权限管理测试";
        message.description = @"中交认证授权服务";
        //        message.messageExt = entData;
        message.mediaObject = object;
        
        message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"40.png"]);;
        
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req completion:^(BOOL success) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
            if (success) {
                params[@"state"] = [NSNumber numberWithInt:1];
            }
            else{
                params[@"state"] = [NSNumber numberWithInt:0];
            }
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"launchWxMiniProgram error: %@",exception.description]);
    } @finally {
        
    }
}

- (void)onReq:(BaseReq*)req{
    
}
- (void)onResp:(BaseResp*)resp{
    
}

@end
