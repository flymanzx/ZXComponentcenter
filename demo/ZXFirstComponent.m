//
//  ZXFirstComponent.m
//  demo
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import "ZXFirstComponent.h"
#import "FirstViewController.h"
@implementation ZXFirstComponent

+ (void)load {
    [ZXComponentCenter registerConnector:[self sharedConnector]];
}

+ (nonnull instancetype)sharedConnector {
    static ZXFirstComponent *_sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConnector = [[ZXFirstComponent alloc] init];
    });
    return _sharedConnector;
}

#pragma mark-- ZXComponentConnectorProtocol
- (BOOL)canOpenURL:(nonnull NSURL *)URL {
    if ([[URL scheme] isEqualToString:@"zx"]) {
        if ([URL.host isEqualToString:@"first"]) {
            return YES;
        }
    }
    return NO;
}

- (nullable UIViewController *)connectToOpenURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params {
    FirstViewController *viewController;
    if ([URL.host isEqualToString:@"first"]) {
        viewController = [FirstViewController  new];
    }
    return viewController;
}

//- (nullable id)connectToHandleProtocol:(nonnull Protocol *)servicePrt {
//
//}




@end
