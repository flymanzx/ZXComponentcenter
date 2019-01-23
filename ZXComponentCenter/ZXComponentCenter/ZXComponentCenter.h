//
//  ZXComponentCenter.h
//  ZXComponentCenter
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ZXComponentCenter.
FOUNDATION_EXPORT double ZXComponentCenterVersionNumber;

//! Project version string for ZXComponentCenter.
FOUNDATION_EXPORT const unsigned char ZXComponentCenterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZXComponentCenter/PublicHeader.h>

/**
 * 中间件向调用者提供:
 *  (1)baseViewController的传递key: kLDRouteViewControllerKey
 *  (2)newController导航方式的传递key: kLDRouteModeKey 目前支持的导航方式有三种；
 */
FOUNDATION_EXTERN NSString *__nonnull const kLDRouteViewControllerKey;
FOUNDATION_EXTERN NSString *__nonnull const kLDRouteModeKey;


#import <ZXComponentCenter/ZXComponentCenterProtocol.h>
/** @interface ZXComponentCenter (组件中心) */

@interface ZXComponentCenter : NSObject

/**
 *  @brief 注册到组件中心
 *  @param connector 实现 ZXComponentConnectorProtocol obj
 */
+ (void)registerConnector:(nonnull id<ZXComponentCenterProtocol>)connector;

/**
 *  @brief 取消注册到组件中心
 *  @param connector 实现 ZXComponentConnectorProtocol obj
 */
+ (void)unRegisterConnector:(nonnull id<ZXComponentCenterProtocol>)connector;

/**
 *  @brief 判断某个URL能否导航
 *  @param URL 可路由的 URL
 */
+ (BOOL)canRouteURL:(nonnull NSURL *)URL;

/**
 *  @brief 通过URL直接完成页面跳转
 *  @param URL 可路由的 URL
 */
+ (BOOL)routeURL:(nonnull NSURL *)URL;

/**
 *  @brief 通过URL直接完成页面跳转
 *  @param URL 可路由的 URL
 *  @param params 携带参数
 */
+ (BOOL)routeURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params;

/**
 *  @brief 通过URL路由获取viewController实例
 *  @param URL 可路由的 URL
 */
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL;

/**
 *  @brief 通过URL路由获取viewController实例
 *  @param URL 可路由的 URL
 *  @param params 携带参数
 */
+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params;

/**
 *  @brief 根据protocol获取服务实例
 *  @param protocol 协议
 */
+ (nullable id)serviceForProtocol:(nonnull Protocol *)protocol;

@end
