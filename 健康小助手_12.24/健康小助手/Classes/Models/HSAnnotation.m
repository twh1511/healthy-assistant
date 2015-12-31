//
//  HSAnnotation.m
//  健康小助手地图
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSAnnotation.h"

@implementation HSAnnotation

-(BOOL)isEqual:(HSAnnotation* )object{
    
    return [self.title isEqual:object.title];
    
}

@end
