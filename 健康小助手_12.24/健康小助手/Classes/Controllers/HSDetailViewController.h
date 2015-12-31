//
//  HSDetailViewController.h
//  小助手
//
//  Created by taren on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDisease.h"

@interface HSDetailViewController : UIViewController
//@property (nonatomic, strong) HSDisease *disease;

- (id)initWithDisease:(HSDisease *)disease;

@end
