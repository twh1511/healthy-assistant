//
//  UITabBarItem+HSBarSetting.m
//  健康小助手
//
//  Created by taren on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "UITabBarItem+HSBarSetting.h"

@implementation UITabBarItem (HSBarSetting)
- (void)setBarWithTitle:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selImageName{
    self.title = title;
    self.image = [UIImage imageNamed:imageName];
    self.selectedImage = [UIImage imageNamed:selImageName];
}
@end
