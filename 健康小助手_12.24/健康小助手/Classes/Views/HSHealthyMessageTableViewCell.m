//
//  HSHealthyMessageTableViewCell.m
//  健康小助手
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSHealthyMessageTableViewCell.h"
@implementation HSHealthyMessageTableViewCell
// row = 60;
-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]init];
        _headImageView.image = [UIImage imageNamed:@"cell_bg_noData_6"];
    }
    return _headImageView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont systemFontOfSize:13];
        _titleLabel.textColor=[UIColor blackColor];
//       _titleLabel.text = @"今天没有好东西";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
       // _timeLabel.backgroundColor = [UIColor redColor];
        
        _timeLabel.textColor = [UIColor lightGrayColor];

    }
    return _timeLabel;
}

-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel=[[UILabel alloc]init];
//        _countLabel.text = @"1200";
        _countLabel.font=[UIFont systemFontOfSize:12];
        _countLabel.textColor=[UIColor grayColor];
    }
    return _countLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.countLabel];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(100);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(200);
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(10);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(130, 20));
        }];
    }
    return  self;
}



@end
