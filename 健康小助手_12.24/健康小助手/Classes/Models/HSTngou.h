//
//  HSTngou.h
//  健康小助手
//
//  Created by tarena on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSTngou : NSObject

@property(nonatomic,strong) NSString* img;
//title
@property(nonatomic,strong) NSString* title;
//访问数
@property(nonatomic,strong) NSString* count;
//简介
@property(nonatomic,strong) NSString* desc;
//评论数
@property(nonatomic,strong) NSString* rcount;
//收藏数
@property(nonatomic,strong) NSString* fcount;

@property(nonatomic,strong) NSString* message;
@property(nonatomic,strong) NSString* keywords;

//发布时间
@property(nonatomic,strong) NSString* time;
@property(nonatomic,strong) NSString* ID;
@end
