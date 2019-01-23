//
//  ZXComponentNavigator.h
//  ZXComponentCenter
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @enum OVSNavigationMode 导航模式
 */
typedef NS_ENUM(NSUInteger, ZXNavigationMode) {
    
    /**
     *  ModeNone
     */
    ZXNavigationModeNone = 0,
    
    /**
     *  push a viewController in NavigationController
     */
    ZXNavigationModePush,
    
    /**
     *  present a viewController in NavigationController
     */
    ZXNavigationModePresent,
    
    /**
     *  pop to the viewController already in NavigationController or tabBarController
     */
    ZXNavigationModeShare
};

/**
 *  @class LDBusNavigator
 *  @brief busMediator内在支持的的导航器
 */
NS_ASSUME_NONNULL_BEGIN

@interface ZXComponentNavigator : NSObject

/**
 * 一个应用一个统一的navigator
 */
+(nonnull ZXComponentNavigator *)navigator;


/**
 * 设置通用的拦截跳转方式；
 */
-(void)setHookRouteBlock:(BOOL (^__nullable)(UIViewController *__nonnull controller, UIViewController *__nullable baseViewController, ZXNavigationMode routeMode)) routeBlock;

/**
 * 在BaseViewController下展示URL对应的Controller
 *  @param controller   当前需要present的Controller
 *  @param baseViewController 展示的BaseViewController
 *  @param routeMode  展示的方式
 */
-(void)showURLController:(nonnull UIViewController *)controller
      baseViewController:(nullable UIViewController *)baseViewController
               routeMode:(ZXNavigationMode)routeMode;

@end

/**
 * 外部不能调用该类别中的方法，仅供Busmediator中调用
 */
@interface ZXComponentNavigator (HookRouteBlock)

-(void)hookShowURLController:(nonnull UIViewController *)controller
          baseViewController:(nullable UIViewController *)baseViewController
                   routeMode:(ZXNavigationMode)routeMode;
@end

NS_ASSUME_NONNULL_END
