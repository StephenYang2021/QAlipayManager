//
//  QAlipayManager.m
//  LearnPublic
//
//  Created by Brother one on 2020/12/10.
//  Copyright © 2020 FZ. All rights reserved.
//

#import "QAlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#define schemeStr @"LearnPublic"

@interface QAlipayManager ()

@property (nonatomic, copy) void (^AlipayResultBlock)(NSNumber * errCode);///9000:支付成功 6001:中途退出 其他:支付失败

@end
@implementation QAlipayManager

+ (instancetype)shareInstance {
    static QAlipayManager *alipaySDK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alipaySDK = [[QAlipayManager allocWithZone:nil] init];
    });
    return alipaySDK;
}

/// 支付宝打开其他app的回调
- (BOOL)handleOpenURL:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSString *resultStatus = resultDic[@"resultStatus"];
        switch (resultStatus.integerValue) {
            case 9000:// 成功
                break;
            case 6001:// 取消
                
                break;
            default: //失败
                break;
        }
        if (self.AlipayResultBlock) {
            self.AlipayResultBlock(@(resultStatus.integerValue));
        }
        
        
    }];
    
    
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
    
    return YES;
}

- (void)payForAlipay:(NSString *)orderString resultBlock:(void(^)(NSNumber *errCode))resultBlock{
    
    _AlipayResultBlock = resultBlock;
        
    [[AlipaySDK defaultService] payOrder:(NSString *)orderString fromScheme:schemeStr callback:^(NSDictionary *resultDic){
        NSString *resultStatus = resultDic[@"resultStatus"];
        switch (resultStatus.integerValue) {
            case 9000:// 成功
                break;
            case 6001:// 取消
                break;
            default:
                break;
        }
        if (self.AlipayResultBlock) {
            self.AlipayResultBlock(@(resultStatus.integerValue));
        }
    }];
}


@end
