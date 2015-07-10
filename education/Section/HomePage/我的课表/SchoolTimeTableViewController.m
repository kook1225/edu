//
//  SchoolTimeTableViewController.m
//  education
//
//  Created by zhujun on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SchoolTimeTableViewController.h"
#import "SETabBarViewController.h"

@interface SchoolTimeTableViewController () {
    SETabBarViewController *tabBarView;
}


@end

@implementation SchoolTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的课表";
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
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
