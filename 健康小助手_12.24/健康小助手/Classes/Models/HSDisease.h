//
//  HSDisease.h
//  健康小助手
//
//  Created by taren on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSDisease : NSObject
//singleton_interface(HSDisease)

/// 名字
@property (nonatomic, copy) NSString *name;
/// 相关症状
@property (nonatomic, copy) NSString *symptom;
/// 内容
@property (nonatomic, copy) NSString *message;
/// 造成原因
@property (nonatomic, copy) NSString *causetext;
/// 治疗方法
@property (nonatomic, copy) NSString *drugtext;
/// 图片
@property (nonatomic, copy) NSString *img;
/// 科室
@property (nonatomic, copy) NSString *department;

@property (nonatomic, copy) NSString *place;
/**
 *  症状描述
 */
@property (nonatomic, copy) NSString *symptomtext;
/**
 *  简介
 */
@property (nonatomic, copy) NSString *desc;
/**
 *  关键字 用于搜索
 */
@property (nonatomic,copy) NSString *keywords;

//--------------
@property (nonatomic, copy) NSString *caretext;
@property (nonatomic, copy) NSString *checks;
@property (nonatomic, copy) NSString *checktext;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *disease;
@property (nonatomic, copy) NSString *diseasetext;
@property (nonatomic, copy) NSString *drug;
@property (nonatomic, assign) NSInteger fcount;
@property (nonatomic, copy) NSString *food;
@property (nonatomic, copy) NSString *foodtext;
@property (nonatomic, assign) NSInteger ID;///
@property (nonatomic, assign) NSInteger rcount;
@end
