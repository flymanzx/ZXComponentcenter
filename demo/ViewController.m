//
//  ViewController.m
//  demo
//
//  Created by Bruce.zhang on 2019/1/21.
//  Copyright © 2019 zhangxin. All rights reserved.
//

#import "ViewController.h"
#import <ZXComponentCenter/ZXComponentCenter.h>
#import <ZXComponentCenter/ZXComponentNavigator.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(onclock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)onclock {
//      [ZXComponentCenter routeURL:[NSURL URLWithString:@"999://first"] withParameters:@{kLDRouteModeKey:@(ZXNavigationModePresent)}];
    [ZXComponentCenter routeURL:[NSURL URLWithString:kINRouterURL_First]];
}
@end
