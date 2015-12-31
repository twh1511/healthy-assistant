//
//  HSLeftMenuSetting.m
//  健康小助手
//
//  Created by taren on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSLeftMenuSetting.h"
#import "HSControllersTool.h"

@implementation HSLeftMenuSetting
//static HSLeftMenuSetting *_menu = nil;

/// 设置左上角按钮
+ (UIBarButtonItem *)setLeftButtonWithClass:(Class)className{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"RightButton"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 50);
//    button.layer.cornerRadius = 20;
//    button.layer.masksToBounds = YES;
    HSControllersTool *controllerTool = [HSControllersTool sharedHSControllersTool];
    if ([controllerTool.healthyVC isMemberOfClass:className]) {
        [button addTarget:controllerTool.healthyVC action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([controllerTool.searchVC isMemberOfClass:className]){
        [button addTarget:controllerTool.searchVC action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button addTarget:controllerTool.mapVC action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

@end
