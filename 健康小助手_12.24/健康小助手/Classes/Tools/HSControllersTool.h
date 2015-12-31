//
//  HSControllersTool.h
//  健康小助手
//
//  Created by taren on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSHealthyMessageViewController.h"
///////
#import "HSSearchHitViewController.h"
#import "HSMapviewController.h"
#import "RESideMenu.h"
///////
#import "HSTabBarController.h"
#import "HSLeftViewController.h"
#import "UITabBarItem+HSBarSetting.h"

@interface HSControllersTool : NSObject<RESideMenuDelegate>
singleton_interface(HSControllersTool)
/// 为了取三个控制器的单例
@property (nonatomic, strong) HSHealthyMessageViewController *healthyVC;
@property (nonatomic, strong) HSSearchHitViewController *searchVC;
@property (nonatomic, strong) HSMapviewController *mapVC;

- (RESideMenu *)setLeftMenuController;

@end
