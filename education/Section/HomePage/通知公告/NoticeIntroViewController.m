//
//  NoticeIntroViewController.m
//  education
//
//  Created by zhujun on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "NoticeIntroViewController.h"

@interface NoticeIntroViewController ()

@end

@implementation NoticeIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知公告详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
