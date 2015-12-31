//
//  HSDetailViewController.m
//  小助手
//
//  Created by taren on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSDetailViewController.h"


#define kImageUrl @"http://tnfs.tngou.net/image"

@interface HSDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@end
@implementation HSDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.label = [UILabel new];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}

@end


@interface HSDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HSDisease *disease;
@end

@implementation HSDetailViewController

- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (UIImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, 0, 250);
        _imageView.backgroundColor = [UIColor grayColor];
        self.tableView.tableHeaderView = _imageView;
        NSString *url = [kImageUrl stringByAppendingFormat:@"%@",self.disease.img];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
    return _imageView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = NO;
    self.imageView.hidden = NO;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[HSDetailCell class] forCellReuseIdentifier:@"detailCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithDisease:(HSDisease *)disease{
    if (self = [super init]) {
        self.disease = disease;
    }
    return self;
}

#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @[@"疾病症状",@"内容描述",@"造成原因",@"治疗方法"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const identifier = @"detailCell";
    HSDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = @[self.disease.symptomtext,self.disease.desc,self.disease.causetext,self.disease.drugtext][indexPath.section];
    return cell;
}

//设置行高自适应
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


@end
