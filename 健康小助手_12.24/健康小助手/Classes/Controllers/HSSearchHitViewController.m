//
//  HSSearchHitViewController.m
//  健康小助手
//
//  Created by taren on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSSearchHitViewController.h"
#import "HSLeftMenuSetting.h"
#import "HSMetaDataTool.h"
#import "HSDisease.h"
#import "HSDetailViewController.h"


#define kListPath @"http://www.tngou.net/api/disease/list?page=%d"
#define kNamePath @"http://www.tngou.net/api/disease/name?name="

@interface HSSearchHitViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *diseases;
//  菊花
@property (nonatomic, strong) MBProgressHUD *progress;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/**
 *  page用于每次请求的页数，每页返回20条信息
    当下拉的时候，这个page要相应的＋1，但是不能把原来的信息覆盖
 */
@property (nonatomic, assign) int page;
/**
 *  用于显示详细的疾病信息
 */
//@property (nonatomic, strong) HSDetailViewController *detailVC;
@end

@implementation HSSearchHitViewController
singleton_implementation(HSSearchHitViewController)

- (AFHTTPSessionManager *)manager {
    if(_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] init];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/xml", nil];
    }
    return _manager;
}

- (UIView *)searchView {
    if(_searchView == nil) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.2 alpha:0.3];
        [self.view addSubview:_searchView];
// 设置搜索视图的约束
        [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(80);
        }];
        [self setSearchBar];
        MYLog(@"%lf,%lf",self.searchBar.bounds.size.width,self.searchBar.bounds.size.height);// 320.000000,44.000000
        [self setSegmentedController];
    }
    return _searchView;
}

/// 设置信息列表
- (UITableView *)tabelView {
    if(_tabelView == nil) {
        _tabelView = [[UITableView alloc] init];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        [self.view addSubview:_tabelView];
        [_tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchView.mas_bottom);
            make.right.left.bottom.mas_equalTo(self.view);
        }];
        
        //创建底部刷新
        _tabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            MYLog(@"上拉刷新");
            self.page ++;
            [self JsonPaseWithPage:self.page];
        }];
    }
    return _tabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ///
    self.view.backgroundColor = [UIColor whiteColor];
    /////
    self.navigationItem.leftBarButtonItem = [HSLeftMenuSetting setLeftButtonWithClass:[HSSearchHitViewController class]];
    /* 设置返回按钮的文字 需在父视图中设置 */
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.searchView.hidden = NO;
    self.tabelView.hidden = NO;
    //初始请求页数为1
    self.page = 1;
    [self JsonPaseWithPage:self.page];
    
    self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
/*
 设置请求参数 rows，查看每次返回的条数。默认20条 page默认＝1
 设置上拉刷新
 */
- (void)JsonPaseWithPage:(int)page{
    NSString *urlStr = [NSString stringWithFormat:kListPath,page];
    // 设置请求参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [self.manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        MYLog(@"请求 - %@",responseObject);
        if (self.page == 1) {
            self.diseases = [[HSMetaDataTool getNameListByJSONParseWithDic:responseObject] mutableCopy];
        }else{
            [self.diseases addObjectsFromArray:[HSMetaDataTool getNameListByJSONParseWithDic:responseObject]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabelView reloadData];
            [self.tabelView.mj_footer endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MYLog(@"%@",error);
    }];
}

/// 设置searchBar
- (void)setSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    [searchBar sizeToFit];
    searchBar.placeholder = @"请输入疾病名称";
    searchBar.delegate = self;
    [self.searchView addSubview:searchBar];
}

//http://www.tngou.net/api/disease/name？name=感冒
#pragma mark - 中文搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *name = searchBar.text;
    NSString *str = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [kNamePath stringByAppendingString:str];
    MYLog(@"url - %@",url);
    [self.manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MYLog(@"responsObject - %@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"不存在该数据！"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                progressHUD.mode = MBProgressHUDModeText;
                progressHUD.labelText = @"请输入正确的疾病名称";
                [progressHUD hide:YES afterDelay:1.5];
            });
            return ;
        }
        HSDisease *disease = [HSMetaDataTool getNameByJSONParseWithDic:responseObject];
        HSDetailViewController *detailVC = [[HSDetailViewController alloc] initWithDisease:disease];
        //            self.detailVC.disease = disease;
        detailVC.navigationItem.title = disease.name;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MYLog(@"error - %@",error);

    }];
    //收键盘
    [searchBar resignFirstResponder];
}

/// 分段按钮
- (void)setSegmentedController{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"按名字分",@"按科室分",@"按症状分"]];
    self.segment = segment;
//    segment.apportionsSegmentWidthsByContent = YES;
    segment.selectedSegmentIndex = 0;
    [self.searchView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.segment addTarget:self action:@selector(clickSegmentIndex:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark－当点击了分段按钮的时候，tableView要相应的改变
- (void)clickSegmentIndex:(UISegmentedControl *)sender{
    MYLog(@"%ld",sender.selectedSegmentIndex);
    [self.tabelView reloadData];
}


#pragma mark - UITableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.diseases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const cellIdentififier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentififier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentififier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    HSDisease *disease = self.diseases[indexPath.row];
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            cell.textLabel.text = disease.name;
            break;
        case 1:
            cell.textLabel.text = disease.department;
            break;
        case 2:
            cell.textLabel.text = disease.symptom;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSDisease *disease = self.diseases[indexPath.row];
    HSDetailViewController *detailVC = [[HSDetailViewController alloc] initWithDisease:disease];
    [self.navigationController pushViewController:detailVC animated:YES];
//    self.detailVC.disease = disease;
    detailVC.navigationItem.title = disease.name;
    detailVC.hidesBottomBarWhenPushed = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [self.diseases removeAllObjects];
}

@end
