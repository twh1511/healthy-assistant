//
//  HSHealtyDetailMessageViewController.m
//  健康小助手
//
//  Created by taren on 15/12/31.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HSHealtyDetailMessageViewController.h"

#define kDetailUrl @"http://www.tngou.net/info/show/%@"//http://www.tngou.net/info/show/101

@interface HSHealtyDetailMessageViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) MBProgressHUD *progress;
@end

@implementation HSHealtyDetailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"快讯详情";
    NSString *str = [NSString stringWithFormat:kDetailUrl,self.ID];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
    self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIWebView *)web {
	if(_web == nil) {
		_web = [[UIWebView alloc] init];
        _web.frame = [[UIScreen mainScreen] bounds];
        _web.delegate = self;
        [self.view addSubview:_web];
	}
	return _web;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"thread - %@",[NSThread currentThread]);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

@end
