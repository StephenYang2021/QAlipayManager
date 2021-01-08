# QAlipayManager
支付宝支付

1.导入支付宝的SDK 建议直接 pod 'AlipaySDK-iOS', '~> 15.7.9'

2.导入头文件 #import "QAlipayManager.h"

3.AppDelegate中 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options；方法中添加 ：
if ([url.host isEqualToString:@"safepay"]) {
        return [[QAlipayManager shareInstance] handleOpenURL:url]; }
       
4.在使用支付宝支付的地方：
[[QAlipayManager shareInstance] payForAlipay:baseModel.data resultBlock:^(NSNumber * _Nonnull errCode) {
                    if ([errCode isEqualToNumber:@(9000)]) {
                        [wSelf requestData];
                    }
                }]; 9000:支付成功 6001:中途退出 其他:支付失败
                baseModel.data 为后台拼接好的支付数据串
    
5.备用方法：
/// 支付宝打开其他app的回调
/// @param url 支付宝启动第三方应用时传递过来的url
- (BOOL)handleOpenURL:(NSURL *)url;

/// 支付宝支付
/// @param orderString   订单信息，后台返回数据
/// @param resultBlock   回调
- (void)payForAlipay:(NSString *)orderString resultBlock:(void(^)(NSNumber *errCode))resultBlock;

6.Targets->Info->URLTypes 配置URLScheme,Identifier填写 alipay 。URL Schemes 填写自己传给支付宝的SchemeStr 

7.完成集成
