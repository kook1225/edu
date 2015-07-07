//
//  SelectPayViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SelectPayViewController.h"
#import "PayEndViewController.h"

@interface SelectPayViewController ()

@end

@implementation SelectPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)zhifubaoPay:(id)sender {
    PayEndViewController *payEndVC = [[PayEndViewController alloc] init];
    [self.navigationController pushViewController:payEndVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
