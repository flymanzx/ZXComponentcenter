//
//  ZXComponentCenter.m
//  ZXComponentCenter
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import "ZXComponentCenter.h"
#import "ZXComponentNavigator.h"
#import "ZXComponentCenterProtocol.h"
#import "ZXComponentTipViewController.h"
#import "UIViewController+NavigationTip.h"
NSString *const kLDRouteViewControllerKey = @"LDRouteViewController";
NSString *__nonnull const kLDRouteModeKey = @"kLDRouteType";

static NSMutableDictionary<NSString *, id<ZXComponentCenterProtocol>> *zx_connectorMap = nil;

@implementation ZXComponentCenter

#pragma mark - 向总控制中心注册挂接点

+ (void)registerConnector:(nonnull id<ZXComponentCenterProtocol>)connector {
    if (![connector conformsToProtocol:@protocol(ZXComponentCenterProtocol)]) {
        return;
    }
    
    @synchronized(zx_connectorMap) {
        if (zx_connectorMap == nil) {
            zx_connectorMap = [[NSMutableDictionary alloc] initWithCapacity:5];
        }
        
        NSString *connectorClsStr = NSStringFromClass([connector class]);
        if ([zx_connectorMap objectForKey:connectorClsStr] == nil) {
            [zx_connectorMap setObject:connector forKey:connectorClsStr];
        }
    }
}

+ (void)unRegisterConnector:(nonnull id<ZXComponentCenterProtocol>)connector {
    if (![connector conformsToProtocol:@protocol(ZXComponentCenterProtocol)] || !zx_connectorMap) {
        return;
    }
    NSString *connectorClsStr = NSStringFromClass([connector class]);
    [zx_connectorMap removeObjectForKey:connectorClsStr];
}



#pragma mark - 页面跳转接口

//判断某个URL能否导航

+ (BOOL)canRouteURL:(nonnull NSURL *)URL {
    if (!zx_connectorMap || zx_connectorMap.count <= 0)
        return NO;
    
    __block BOOL success = NO;
    //遍历connector不能并发
    [zx_connectorMap
     enumerateKeysAndObjectsWithOptions:NSEnumerationReverse
     usingBlock:^(NSString *_Nonnull key,
                  id<ZXComponentCenterProtocol> _Nonnull connector, BOOL *_Nonnull stop) {
         if ([connector respondsToSelector:@selector(canOpenURL:)]) {
             if ([connector canOpenURL:URL]) {
                 success = YES;
                 *stop = YES;
             }
         }
     }];
    
    return success;
}


+ (BOOL)routeURL:(nonnull NSURL *)URL {
    return [self routeURL:URL withParameters:nil];
}


+ (BOOL)routeURL:(nonnull NSURL *)URL withParameters:(nullable NSDictionary *)params {
    if (!zx_connectorMap || zx_connectorMap.count <= 0)
        return NO;
    
    __block BOOL success = NO;
    __block int queryCount = 0;
    NSDictionary *userParams = [self userParametersWithURL:URL andParameters:params];
    [zx_connectorMap
     enumerateKeysAndObjectsWithOptions:NSEnumerationReverse
     usingBlock:^(NSString *_Nonnull key,
                  id<ZXComponentCenterProtocol> _Nonnull connector, BOOL *_Nonnull stop) {
         queryCount++;
         if ([connector respondsToSelector:@selector(connectToOpenURL:params:)]) {
             id returnObj = [connector connectToOpenURL:URL params:userParams];
             if (returnObj && [returnObj isKindOfClass:[UIViewController class]]) {
                 if ([returnObj isKindOfClass:[ZXComponentTipViewController class]]) {
                     // DEBUG 下提示控制器
                     ZXComponentTipViewController *tipController =
                     (ZXComponentTipViewController *)returnObj;
                     if (tipController.isNotURLSupport) {
                         success = YES;
                     } else {
                         success = NO;
#if DEBUG
                         [tipController showDebugTipController:URL withParameters:params];
                         success = YES;
#endif
                     }
                 } else if ([returnObj class] == [UIViewController class]) {
                     success = YES;
                 } else {
                     [[ZXComponentNavigator navigator]
                      hookShowURLController:returnObj
                      baseViewController:params[kLDRouteViewControllerKey]
                      routeMode:params[kLDRouteModeKey] ?
                      [params[kLDRouteModeKey] intValue] :
                      ZXNavigationModePush];
                     success = YES;
                 }
                 
                 *stop = YES;
             }
         }
     }];
//    ZXComponentNavigator
//    ZXComponentTipViewController
    
#if DEBUG
    if (!success && queryCount == zx_connectorMap.count) {
        [((ZXComponentTipViewController *)[UIViewController notFound]) showDebugTipController:URL
                                                                                         withParameters:params];
        return NO;
    }
#endif
    
    return success;
}


+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL {
    return [self viewControllerForURL:URL withParameters:nil];
}


+ (nullable UIViewController *)viewControllerForURL:(nonnull NSURL *)URL
                                     withParameters:(nullable NSDictionary *)params {
    if (!zx_connectorMap || zx_connectorMap.count <= 0)
        return nil;
    
    __block UIViewController *returnObj = nil;
    __block int queryCount = 0;
    NSDictionary *userParams = [self userParametersWithURL:URL andParameters:params];
    
    [zx_connectorMap
     enumerateKeysAndObjectsWithOptions:NSEnumerationReverse
     usingBlock:^(NSString *_Nonnull key,
                  id<ZXComponentCenterProtocol> _Nonnull connector, BOOL *_Nonnull stop) {
         queryCount++;
         if ([connector respondsToSelector:@selector(connectToOpenURL:params:)]) {
             returnObj = [connector connectToOpenURL:URL params:userParams];
             if (returnObj && [returnObj isKindOfClass:[UIViewController class]]) {
                 *stop = YES;
             }
         }
     }];
    
    
#if DEBUG
    if (!returnObj && queryCount == zx_connectorMap.count) {
        [((ZXComponentTipViewController *)[UIViewController notFound]) showDebugTipController:URL
                                                                                         withParameters:params];
        return nil;
    }
#endif
    
    
    if (returnObj) {
        if ([returnObj isKindOfClass:[ZXComponentTipViewController class]]) {
#if DEBUG
            [((ZXComponentTipViewController *)returnObj) showDebugTipController:URL withParameters:params];
#endif
            return nil;
        } else if ([returnObj class] == [UIViewController class]) {
            return nil;
        } else {
            return returnObj;
        }
    }
    
    return nil;
}


/**
 * 从url获取query参数放入到参数列表中
 */

+ (NSDictionary *)userParametersWithURL:(nonnull NSURL *)URL andParameters:(nullable NSDictionary *)params {
    NSArray *pairs = [URL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *userParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [kv objectAtIndex:0];
            NSString *value = [self URLDecodedString:[kv objectAtIndex:1]];
            [userParams setObject:value forKey:key];
        }
    }
    [userParams addEntriesFromDictionary:params];
    return [NSDictionary dictionaryWithDictionary:userParams];
}


/**
 * 对url的value部分进行urlDecoding
 */

+ (nonnull NSString *)URLDecodedString:(nonnull NSString *)urlString {
    NSString *result = urlString;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                   kCFAllocatorDefault, (__bridge CFStringRef)urlString, CFSTR(""), kCFStringEncodingUTF8);
#else
    result = [urlString stringByRemovingPercentEncoding];
#endif
    return result;
}


#pragma mark - 服务调用接口

+ (nullable id)serviceForProtocol:(nonnull Protocol *)protocol {
    if (!zx_connectorMap || zx_connectorMap.count <= 0)
        return nil;
    
    __block id returnServiceImp = nil;
    [zx_connectorMap
     enumerateKeysAndObjectsWithOptions:NSEnumerationReverse
     usingBlock:^(NSString *_Nonnull key,
                  id<ZXComponentCenterProtocol> _Nonnull connector, BOOL *_Nonnull stop) {
         if ([connector respondsToSelector:@selector(connectToHandleProtocol:)]) {
             returnServiceImp = [connector connectToHandleProtocol:protocol];
             if (returnServiceImp) {
                 *stop = YES;
             }
         }
     }];
    
    return returnServiceImp;
}
@end
