//
//  ZXComponentTipViewController.h
//  ZXComponentCenter
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXComponentTipViewController : UIViewController

@property (nonatomic, readonly) BOOL isparamsError;
@property (nonatomic, readonly) BOOL isNotURLSupport;
@property (nonatomic, readonly) BOOL isNotFound;

+(nonnull UIViewController *)paramsErrorTipController;

+(nonnull UIViewController *)notURLTipController;

+(nonnull UIViewController *)notFoundTipConctroller;

-(void)showDebugTipController:(nonnull NSURL *)URL
               withParameters:(nullable NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
