//
//  HSLeftViewController.m
//  健康小助手
//
//  Created by taren on 15/12/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSLeftViewController.h"

@interface HSLeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@end

@implementation HSLeftViewController

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"个人信息",@"病例卡",@"设置",@"主界面"];
    }
    return _titles;
}

- (NSArray *)images{
    if (!_images) {
        _images = @[@"IconProfile",@"IconCalendar",@"IconSettings",@"IconHome"];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMenuTableView];
}

/// 设置菜单tableview
- (void)setMenuTableView{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        // 大小按比例变化(视图外面的红线)
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
//        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        
//        cell.selectedTextColor = [UIColor redColor];
        cell.selectedBackgroundView = [UIView new];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MYLog(@"%ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
