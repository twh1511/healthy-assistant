//
//  HSTabBarController.m
//  健康小助手
//
//  Created by taren on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSTabBarController.h"

@interface HSTabBarController ()

@end

@implementation HSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)initialize{
    if (self == [HSTabBarController class]) {
        UITabBar *tabBar = [UITabBar appearance];
        //设置tabBar的背景
        [tabBar setBackgroundImage:[UIImage imageNamed:@"toolbarBkg_white"]];
        
        //获取TabBarItem的外观实例
        UITabBarItem *barItem = [UITabBarItem appearance];
        
        //barItem中文字的位置偏移量
        [barItem setTitlePositionAdjustment:UIOffsetMake(0, -1)];
        
        NSMutableDictionary *seletedAttributes = [NSMutableDictionary dictionary];
        //设置前景色
//        seletedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0 alpha:1.0];
        seletedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:11];
        [barItem setTitleTextAttributes:seletedAttributes forState:UIControlStateSelected];
        
        //设置item没有被选中时的字体颜色
        NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
//        normalAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0];
        normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:11];
        [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        
        
    }
}
@end
