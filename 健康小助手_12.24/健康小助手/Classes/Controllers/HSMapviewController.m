//
//  HSMapviewController.m
//  健康小助手地图
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSMapviewController.h"
#import <MapKit/MapKit.h>
#import "HSAnnotation.h"
#import "HSRegiontngou.h"
#import "HSMetaDataTool.h"
//#import "HSMapDetailviewViewController.h"
#define  BMKSPAN  0.002
@interface HSMapviewController ()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView* mapView;

@property(nonatomic,strong) CLLocationManager* manager;

@property (nonatomic,strong) UILabel* label;

@property(nonatomic,strong) CLGeocoder* geocoder;

@property (nonatomic,strong) UIButton* button;

@property (nonatomic, strong) MKUserLocation  *userLocation;  ///< 用户定位

@end

@implementation HSMapviewController
singleton_implementation(HSMapviewController)

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

-(UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:0];
       // _button.backgroundColor = [UIColor redColor];
        [_button setImage:[UIImage imageNamed:@"draw_point"] forState:UIControlStateNormal];
        [self.mapView addSubview:_button];
        [_button addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-80);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _button;
}

-(void)clickbutton{

    self.label.hidden = YES;
}

-(UILabel* )label{
    if (_label == nil) {
        _label = [UILabel new];
        [self.mapView addSubview:_label];
        _label.text = @"正在定位中...";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont fontWithName:@"San Francisco" size:20];
        _label.backgroundColor = [UIColor blackColor];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0;
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.bottom.mas_equalTo(self.mapView.mas_top);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(50);
        }];
    }
    return _label;
}

- (MKMapView *) mapView {
    if(_mapView == nil) {
        _mapView = [[MKMapView alloc] init];
        [self.view addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.bottom.mas_equalTo(0);
        }];
    }
    return _mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.hidden = NO;
    self.mapView.hidden = NO;
    self.button.hidden = NO;
    //征求用户同意(iOS8+/假定用户iOS8+/Info.plist)
    self.manager = [CLLocationManager new];
    //假定用户同意定位
    [self.manager requestWhenInUseAuthorization];
    //开始定位
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置代理
    self.mapView.delegate = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.label.hidden = YES;
    
    //只定位一次
    if(self.userLocation)
        return;
    self.userLocation = userLocation;
    
    //设置区域
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000);
    [mapView setRegion:region];
    
    /*[self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark* placemark = [placemarks firstObject];
        NSString* cityName = placemark.addressDictionary[@"City"];
        self.label.text = cityName;
        NSLog(@"%@",cityName);
    }];
    */
    [self showAnnotions];
}


//展示大头针方法
- (void)showAnnotions
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    NSString* path =[NSString stringWithFormat:@"http://www.tngou.net/api/hospital/location?x=%f&y=%f",self.mapView.region.center.longitude,self.mapView.region.center.latitude];
    [manager POST:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",path);
        NSDictionary*dic=responseObject;
        NSArray* tngouArray = [HSMetaDataTool getTngouFromServer:dic];
        if (tngouArray == 0) {
            return ;
        }
        for (HSRegiontngou* region in tngouArray) {
            self.label.text = region.name;
            HSAnnotation* annotation = [HSAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake((CLLocationDegrees)region.y, (CLLocationDegrees)region.x);
            annotation.title = region.name;
            annotation.subtitle = region.address;
            annotation.image = [UIImage imageNamed:@"ic_net_map_locationtop"];
            annotation.gobus = region.gobus;
            if (![self.mapView.annotations containsObject:annotation]) {
                [self.mapView addAnnotation:annotation];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络失败%@",error);
    }];
}
//地图区域发生移动
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //[self showAnnotions];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //把蓝色圈排除
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if([annotation isKindOfClass:[HSAnnotation class]]){
        //写重用机制
        HSAnnotation *anotion = (HSAnnotation *)annotation;
        static NSString *identifier = @"annotation";
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
 //           #warning 这里用annotion 强转之后的anotion ?不行？
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            //显示弹出框
            annotationView.canShowCallout = YES;
        }
        // 是否可以拖拽
        annotationView.draggable = NO;
        annotationView.annotation = anotion;
        //这里要设置image
        annotationView.image = anotion.image;
        return annotationView;
    }
    
    return nil;
   

    
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位错误%@",error);

}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    self.label.hidden = NO;
    HSAnnotation *annotation = (HSAnnotation *)view.annotation;
    self.label.text = annotation.gobus;
}

@end
