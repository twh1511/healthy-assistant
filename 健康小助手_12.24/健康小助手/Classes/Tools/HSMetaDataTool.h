//
//  HSMetaDataTool.h
//  健康小助手
//
//  Created by taren on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSDisease.h"

@interface HSMetaDataTool : NSObject
//singleton_interface(HSMetaDataTool)
/// 解析疾病列表，返回名字
+ (NSArray *)getNameListByJSONParseWithDic:(NSDictionary *)dic;

+ (HSDisease *)getNameByJSONParseWithDic:(NSDictionary *)dic;

+ (NSArray* )getTngouFromServer:(NSDictionary* )NSDic;

// 返回新闻列表
+ (NSArray* )getNewsListByJSONParseWithDic:(NSDictionary* )jsonDic;




@end
