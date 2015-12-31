//
//  HSMetaDataTool.m
//  健康小助手
//
//  Created by taren on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSMetaDataTool.h"
#import "HSRegiontngou.h"

#import "HSTngou.h"

@interface HSMetaDataTool ()
@end

@implementation HSMetaDataTool
//singleton_implementation(HSMetaDataTool)
//   疾病名称详情列表 http://www.tngou.net/api/disease/name ?name=感冒
//   图片http://tnfs.tngou.net/image 前缀拼接

+ (NSArray *)getNameListByJSONParseWithDic:(NSDictionary *)dic{
    NSArray *array = dic[@"list"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        HSDisease *disease = [[HSDisease alloc] init];
        [disease setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:disease];
    }
    return mutableArray;
}

+ (NSArray *)getTngouFromServer:(NSDictionary *)NSDic{
    NSArray* array = NSDic[@"tngou"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary* regionDic in array) {
        HSRegiontngou* tngou = [HSRegiontngou new];
        [tngou setValuesForKeysWithDictionary:regionDic];
        [mutableArray addObject:tngou];
    }
    return [mutableArray copy];
}

+ (NSArray *)getNewsListByJSONParseWithDic:(NSDictionary *)jsonDic{
    NSArray* array = jsonDic[@"tngou"];
    NSMutableArray* mutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in array) {
        HSTngou *deal = [HSTngou new];
        [deal setValuesForKeysWithDictionary:dealDic];
        [mutableArray addObject:deal];
    }
    return mutableArray ;
}

+ (HSDisease *)getNameByJSONParseWithDic:(NSDictionary *)dic{
    HSDisease *disease = [[HSDisease alloc] init];
    [disease setValuesForKeysWithDictionary:dic];
    return disease;
}

@end
