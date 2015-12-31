//
//  HSAnnotation.h
//  健康小助手地图
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface HSAnnotation : NSObject<MKAnnotation>
//坐标
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
//两个title
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//自定义图片
@property(nonatomic, strong) UIImage *image;

@property (nonatomic,strong) NSString *gobus;

@end
