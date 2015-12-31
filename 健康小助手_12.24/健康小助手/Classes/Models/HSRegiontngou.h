//
//  HSRegiontngou.h
//  健康小助手地图
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSRegiontngou : NSObject
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSString* count;
@property (nonatomic,strong) NSString* fcount;
@property (nonatomic,strong) NSString* ID;


///路线
@property (nonatomic,strong) NSString* gobus;
///医院名字
@property (nonatomic,strong) NSString* name;

@property (nonatomic,assign) double x; //经纬度用double
@property (nonatomic,assign) double y;


@end
