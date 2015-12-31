//
//  HSDisease.m
//  健康小助手
//
//  Created by taren on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSDisease.h"

@implementation HSDisease
//singleton_implementation(HSDisease)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}
@end
