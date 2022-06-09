//
//  ZJDigitalAuthSDK1.h
//  ZJDigitalAuthSDK
//
//  Created by jiaoxt on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ZJDigitalComlietionBlock) (NSDictionary *_Nullable resultData, NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface ZJDigitalAuthSDK : NSObject



#pragma mark - 1、初始化SDK
/**
 
 初始化认证SDK。鉴权结果通过completion中的方法回调给开发者
 @param appId 在中交开放平台注册生成的appId，由于中交公司提供
 @param appSecret 在中交开放平台注册生成的appSecret，由于中交公司提供
 @param completion 初始化回调函数
 
 */
+ (void)initWithAppId:(NSString *)appId
            appSecret:(NSString *)appSecret
           completion:(ZJDigitalComlietionBlock)completion;

#pragma mark - 2、设置实名认证回调函数
/**
 
 设置【实名认证】回调函数, 设置后实名认证成功和失败时都会调用该函数
 @param realNameAuthCallBack 实名认证回调函数
 */
+(void)setRealNameAuthResultCallBack:(ZJDigitalComlietionBlock)realNameAuthCallBack;


#pragma mark - 3、设置车主认证回调函数
/**
 
 设置【车辆认证】回调函数, 设置后实名认证成功和失败时都会调用该函数
 @param vehicleAuthResultCallBack 车辆认证回调函数
 
 */
+(void)setVehicleAuthResultCallBack:(ZJDigitalComlietionBlock)vehicleAuthResultCallBack;

#pragma mark - 4、设置小程序授权链接回调函数

/**
 设置微信【小程序授权】回调函数
 @param shareCallBack 点击授权链接时回调函数
 */
+(void)setWXSmallProgramShareInfoResultCallBack:(ZJDigitalComlietionBlock)shareCallBack;


#pragma mark - 5、实名认证
/**
 
 开始实名认证
 @param ticket SDK初始化完后会返回该信息（必填）
 @param currentContrller        当前的controller,支持UIViewController和UINavigationController及其子类(必填)
 
 */
+ (void)startRealNameAuthWithTicket:(NSString *)ticket
                   currentContrller:(UIViewController *)currentContrller;


#pragma mark - 6、车辆授权
/**
 
 开始车辆授权
 @param ticket SDK初始化完后会返回该信息（必填）
 @param appUserId 实名认证后返回的信息（必填）
 @param currentContrller 当前的controller,支持UIViewController和UINavigationController及其子类（必填）
 
 */
+ (void)startVehicleOwerAuthWithTicket:(NSString *)ticket
                             appUserId:(NSString *)appUserId
                      currentContrller:(UIViewController *)currentContrller;



#pragma mark - 7、查询车辆的授权信息
/**
 
 查询车辆的授权信息
 @param appUserId 实名认证后返回的信息（必填）
 @param vno 车牌号（必填）
 @param resultCallBack 回调结果
 
 */
+ (void)queryVehicleAuthInfo:(NSString *)appUserId
                         vno:(NSString *)vno
              resultCallBack:(ZJDigitalComlietionBlock)resultCallBack;




#pragma mark - 8、验证appUserId是否有效
/**
 验证appUserId是否有效
 @param appUserId 实名认证后返回的信息（必填）
 @param resultCallBack 回调结果
 */
+ (void)validAppUserId:(NSString *)appUserId
        resultCallBack:(ZJDigitalComlietionBlock)resultCallBack;




#pragma mark - 9、实名认证用户过期后重新同意【隐私协议】
/**
 实名认证用户过期后重新同意隐私协议
 @param appUserId        实名认证后返回的appUserIs,【注意不是前置用户id】（必填）
 @param currentContrller 当前的controller,支持UIViewController和UINavigationController及其子类（必填）
 @param resultCallBack 回调结果,回调结果,返回格式为 result:{desc:"描述",resultType:"1：成功，2：不成功"}
 */
+ (void)openAgreementPage:(NSString *)appUserId
         currentContrller:(UIViewController *)currentContrller
           resultCallBack:(ZJDigitalComlietionBlock)resultCallBack;


#pragma mark - 10、打开同意【隐私协议】和【知情通知书】页面
/**
 打开同意【隐私协议】和【知情通知书】页面
 @param preUserId 实名认证后返回的信息（必填）
 @param currentContrller 当前的controller,支持UIViewController和UINavigationController及其子类（必填）
 @param resultCallBack 回调结果,回调结果,返回格式为 result:{desc:"描述",resultType:"1：成功，2：不成功"}
 */
+ (void)openTwoAgreementsPage:(NSString *)preUserId
             currentContrller:(UIViewController *)currentContrller
               resultCallBack:(ZJDigitalComlietionBlock)resultCallBack;


#pragma mark - 11、生成前置生用户
/**
 验证appUserId是否有效
 @param  name   姓名（必填）
 @param  idCard 身份证号（必填）
 @param  phone  手机号（必填）
 @param  authResult 身份证号（必填）
 @param  authTime  手机号（必填）
 @param resultCallBack 回调结果,回调结果,返回格式为 {result:{preUserId:"12321312441"},message:"状态码信息 ",status:"状态码"}
 */

+ (void)registerPreUserWithName:(NSString *)name
                         idCard:(NSString *)idCard
                          phone:(NSString *)phone
                     authResult:(NSString *)authResult
                       authTime:(NSString *)authTime
                 resultCallBack:(ZJDigitalComlietionBlock)resultCallBack;
#pragma mark - 手动关闭认证页面
+ (void)closeAuthPage;


/**
 *  获取SDK版本号
 *
 *  @return SDK版本号
 */
+ (NSString *)sdkVersion;


/**
 *  是否开户日志打印，默认NO，如想获取日志打印，请在初始SDK前执行
 *  @param enableLog 是否开启日志打印，默认NO
 *
 */
+ (void)enableLog:(BOOL)enableLog;

+ (void)enableDebug:(BOOL)enableDebug;


@end

NS_ASSUME_NONNULL_END
