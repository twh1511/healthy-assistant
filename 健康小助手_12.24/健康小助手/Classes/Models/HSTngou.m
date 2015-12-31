//
//  HSTngou.m
//  健康小助手
//
//  Created by tarena on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSTngou.h"

@implementation HSTngou

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //判定key如果是description, 指定字典的value给desc属性
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.ID=value;
    }
    
}


@end
