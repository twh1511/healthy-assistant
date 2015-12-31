//
//  HSRegiontngou.m
//  健康小助手地图
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSRegiontngou.h"

@implementation HSRegiontngou
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"ID"]) {
        self.ID = value;
    }
   
}
@end
