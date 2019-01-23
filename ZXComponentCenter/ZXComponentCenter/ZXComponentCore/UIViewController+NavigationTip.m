//
//  UIViewController+NavigationTip.m
//  ZXComponentCenter
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import "UIViewController+NavigationTip.h"
#import "ZXComponentTipViewController.h"
/**
 * @category NavigationTip
 *  中间件导航的错误提示
 */
@implementation UIViewController (NavigationTip)

+(nonnull UIViewController *) paramsError{
    return [ZXComponentTipViewController paramsErrorTipController];
}


+(nonnull UIViewController *) notFound{
    return [ZXComponentTipViewController notFoundTipConctroller];
}


+(nonnull UIViewController *) notURLController{
    return [ZXComponentTipViewController notURLTipController];
}



@end
