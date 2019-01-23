//
//  ZXComponentCenterProtocol.h
//  ZXComponentCenter
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ZXComponentCenterProtocol <NSObject>
/**
 * @brief 当前业务组件可导航的URL询问判断
 * @param URL 可路由的 URL
 */

- (BOOL)canOpenURL:(nonnull NSURL *)URL;

/**
 * @brief 业务模块挂接中间件，注册自己能够处理的URL，完成url的跳转
 * @param URL 可路由的 URL
 * @param params 参数
 */

- (nullable UIViewController *)connectToOpenURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params;

/**
 * @brief 业务模块挂接中间件，注册自己提供的service，实现服务接口的调用；
 * @param servicePrt 议找到组件中对应的服务实现，生成一个服务单例
 */

- (nullable id)connectToHandleProtocol:(nonnull Protocol *)servicePrt;

@end

NS_ASSUME_NONNULL_END
