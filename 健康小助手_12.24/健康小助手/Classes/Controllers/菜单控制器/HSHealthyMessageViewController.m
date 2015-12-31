//
//  HSHealthyMessageViewController.m
//  健康小助手
//
//  Created by taren on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSHealthyMessageViewController.h"
#import "HSLeftMenuSetting.h"
#import "WMLoopView.h"
#import "HSHealthyMessageTableViewCell.h"
#import "HSMetaDataTool.h"
#import "HSTngou.h"
#import "WMPageConst.h"
#import "HSHealtyDetailMessageViewController.h"



#define kNEWSPATH @"http://www.tngou.net/api/info/list?page=%d"
#define kImageUrl @"http://tnfs.tngou.net/image"

@interface HSHealthyMessageViewController ()<UITableViewDelegate,UITableViewDataSource,WMLoopViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray *news;

@property (nonatomic, strong) MBProgressHUD *progress;

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong) WMLoopView *loopView;
@property(nonatomic,strong)NSMutableArray *images;

/**
 *  page用于每次请求的页数，每页返回20条信息
 当下拉的时候，这个page要相应的＋1，但是不能把原来的信息覆盖
 */
@property (nonatomic, assign) int page;

@end

@implementation HSHealthyMessageViewController

singleton_implementation(HSHealthyMessageViewController)

-(NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (AFHTTPSessionManager *)manager {
    if(_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] init];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/xml", nil];
    }
    return _manager;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 70.0;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        //创建底部刷新
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            MYLog(@"上拉刷新");
            self.page ++;
            [self JsonPaseWithPage:self.page];
        }];

    }
    return _tableView;
}
#pragma 时间管理
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = [HSLeftMenuSetting  setLeftButtonWithClass:[HSHealthyMessageViewController class]];
    
    [self.tableView registerClass:[HSHealthyMessageTableViewCell class] forCellReuseIdentifier:@"listIdentifier"];
    
    [self setLoopView];
    
    //发请求
    self.page = 1;
    [self JsonPaseWithPage:self.page];
    
    self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
/*
-(void)getimage:(NSArray*)array
{
    for (int i=0; i<5; i++) {
        
        HSTngou*tngou=array[i];
        NSString*imgstr=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",tngou.img];
        NSURL*imgurl=[NSURL URLWithString:imgstr];
        
        NSData*imgdata=[NSData dataWithContentsOfURL:imgurl];
        [self.imageArray addObject:[UIImage imageWithData:imgdata]];
        
        
        
    }
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < 5; ++i) {
        
        UIImageView*imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width,150)];
        imageview.image = [self.imageArray objectAtIndex:i];
        [viewsArray addObject:imageview];
        
        
    }
    
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150) animationDuration:2];
    
    self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return 5;
    };
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",(long)pageIndex);
    };
    
    [self.view addSubview:self.mainScorllView];
    
}
*/
/**
 *  tableView头部滚动视图
 */

- (void)setLoopView{
    /*
    if (array == nil) {
        array = @[@"cell_bg_noData_1",@"cell_bg_noData_2",@"cell_bg_noData_3",@"cell_bg_noData_4",@"cell_bg_noData_5"];
        
        
    }
    
    
    for (int i=0; i<5; i++) {
        
        HSTngou*tngou=array[i];
        NSString*imgstr=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",tngou.img];
        NSURL*imgurl=[NSURL URLWithString:imgstr];
        
        NSData*imgdata=[NSData dataWithContentsOfURL:imgurl];
        [self.imageArray addObject:[UIImage imageWithData:imgdata]];
        
    
    }/*
    /*
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < 5; ++i) {
        
        UIImageView*imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width,150)];
        imageview.image = [self.imageArray objectAtIndex:i];
        [viewsArray addObject:imageview];
        
        
    }*/
    //默认显示图
    self.imageArray = [@[@"cell_bg_noData_1",@"cell_bg_noData_2",@"cell_bg_noData_3"]mutableCopy];
    NSArray *arry = @[@"",@"",@""];
   // NSArray *images = self.imageArray;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.loopView = [[WMLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150) images:self.imageArray autoPlay:YES delay:4.0];
    self.loopView.delegate = self;
    self.tableView.tableHeaderView = self.loopView;
    
    
}


/*
 设置请求参数 rows，查看每次返回的条数。默认20条 page默认＝1
 设置上拉刷新
 */

#pragma mark - Json
- (void)JsonPaseWithPage:(int)page{
    NSString *urlStr = [NSString stringWithFormat:kNEWSPATH,page];
    // 设置请求参数
    //    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self.manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MYLog(@"请求 - %@",responseObject);
        if (self.page == 1) {
            self.news = [[HSMetaDataTool getNewsListByJSONParseWithDic:responseObject] mutableCopy];
            HSTngou *new = self.news[1];
            MYLog(@"news - %@",new.title);
            
            for (int i=0; i<3; i++) {
                HSTngou *new = self.news[i];
                NSString *imageStr = [kImageUrl stringByAppendingFormat:@"%@",new.img];
                MYLog(@"imageUrl - %@",imageStr);
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
                UIImage *image = [UIImage imageWithData:data];
                [self.images addObject:image];
            }
            
            
            
        }else{
            [self.news addObjectsFromArray:[HSMetaDataTool getNewsListByJSONParseWithDic:responseObject]];
        }
        
        
        //[self setLoopView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MYLog(@"%@",error);
    }];
}


#pragma mark - UITabelView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const identifier = @"listIdentifier";
    HSHealthyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    HSTngou *new = self.news[indexPath.row];
    MYLog(@"new - %@",new.title);
    MYLog(@"time - %@",new.time);
    MYLog(@"conut - %@",new.count);
    
    cell.titleLabel.text = new.title;
    cell.timeLabel.text = [self bySecondGetDate:new.time];
    cell.countLabel.text = [NSString stringWithFormat:@"评论数:%@", new.count];
    NSString *url = [kImageUrl stringByAppendingFormat:@"%@",new.img];
    MYLog(@"url - %@",url);
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSTngou* tngou = self.news[indexPath.row + 1];
    HSHealtyDetailMessageViewController* dmvc = [[HSHealtyDetailMessageViewController alloc]init];
    dmvc.ID = tngou.ID;
    [self.navigationController pushViewController:dmvc animated:YES];
    //dmvc.navigationItem.title = tngou.title;
    dmvc.hidesBottomBarWhenPushed = YES;
}

-(NSString* )bySecondGetDate:(NSString* )second{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.dateFormat = @"2015年MM月dd日 hh:mm:ss";
    NSString *dateLoca = [NSString stringWithFormat:@"%@",second];
    NSTimeInterval time = [dateLoca doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timestr = [formatter stringFromDate:detaildate];
    return timestr;
    //long long int date = (long long int)[second intValue];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    //释放资源（imageDic）它占的是内存
    [self.news removeAllObjects];
    
}

@end
