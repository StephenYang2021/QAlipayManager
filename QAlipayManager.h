//
//  QAlipayManager.h
//  LearnPublic
//
//  Created by Brother one on 2020/12/10.
//  Copyright © 2020 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAlipayManager : NSObject

/// 单例
+ (instancetype)shareInstance;

/// 支付宝打开其他app的回调
/// @param url 支付宝启动第三方应用时传递过来的url
- (BOOL)handleOpenURL:(NSURL *)url;

/// 支付宝支付
/// @param orderString   订单信息，后台返回数据
/// @param resultBlock   回调
- (void)payForAlipay:(NSString *)orderString resultBlock:(void(^)(NSNumber *errCode))resultBlock;



@end

NS_ASSUME_NONNULL_END
