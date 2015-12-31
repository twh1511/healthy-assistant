//
//  HSControllersTool.m
//  健康小助手
//
//  Created by taren on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSControllersTool.h"

@implementation HSControllersTool
singleton_implementation(HSControllersTool)

/** 设置左上角弹出菜单 */
- (RESideMenu *)setLeftMenuController{
    self.healthyVC = [HSHealthyMessageViewController sharedHSHealthyMessageViewController];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.healthyVC];
    self.healthyVC.navigationItem.title = @"健康快讯";
    [navi.tabBarItem setBarWithTitle:@"健康快讯" andImageName:@"find_finance" andSelectedImageName:@"find_finance"];
    
//#warning 第二、三个控制器
    self.searchVC = [HSSearchHitViewController sharedHSSearchHitViewController];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:self.searchVC];
    self.searchVC.navigationItem.title = @"疾病查询";
    [navi2.tabBarItem setBarWithTitle:@"疾病查询" andImageName:@"icon_search" andSelectedImageName:@"icon_search_highlighted"];
    self.mapVC = [HSMapviewController sharedHSMapviewController];
//    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:self.mapVC];
//    self.mapVC.navigationItem.title = @"医院定位";
    [self.mapVC.tabBarItem setBarWithTitle:@"医院定位" andImageName:@"icon_map" andSelectedImageName:@"icon_map_highlighted"];
    
//#warning 设置TabBar控制器
    HSTabBarController *tabBar = [[HSTabBarController alloc] init];
    tabBar.viewControllers = @[navi,navi2,self.mapVC];
    
    
//#warning 设置Menu控制器
    HSLeftViewController *leftVC = [[HSLeftViewController alloc] init];
    RESideMenu *menuVC = [[RESideMenu alloc] initWithContentViewController: tabBar leftMenuViewController:leftVC rightMenuViewController:nil];
    // 设置menu的背景图片
    // 也就是左边弹出的菜单视图的背景图
    menuVC.backgroundImage = [UIImage imageNamed:@"deskTop.jpeg"];
    menuVC.menuPreferredStatusBarStyle = 1;//UIStatusBarStyleLightContent
    menuVC.delegate = self;
    menuVC.contentViewShadowColor = [UIColor blackColor];
    menuVC.contentViewShadowOffset = CGSizeMake(0, 0);
    // 不透明－－模糊
    menuVC.contentViewShadowOpacity = 0.6;
    menuVC.contentViewShadowRadius = 12;
    menuVC.contentViewShadowEnabled = NO;
    
    return menuVC;
}

@end
