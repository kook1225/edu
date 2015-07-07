//
//  AddReceiveAddressViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "AddReceiveAddressViewController.h"

@interface AddReceiveAddressViewController ()

@end

@implementation AddReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增收货地址";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
