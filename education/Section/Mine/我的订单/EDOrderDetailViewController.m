//
//  EDOrderDetailViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDOrderDetailViewController.h"
#import "SETabBarViewController.h"

@interface EDOrderDetailViewController ()
{
    SETabBarViewController *tabBarView;
}

@end

@implementation EDOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawlayer
{
    _commitBtn.layer.cornerRadius = 4.0f;
    _commitBtn.layer.masksToBounds = YES;
    
    _cancelBtn.layer.cornerRadius = 4.0f;
    _cancelBtn.layer.masksToBounds = YES;
    
    _cancelBtn.layer.borderColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0].CGColor;
    _cancelBtn.layer.borderWidth = 1.0;
    _nonAddress.hidden = YES;
    
    if ([_type isEqualToString:@"1"]) {
        _bottomView.hidden = YES;
    }else if ([_type isEqualToString:@"2"])
    {
        _cancelBtn.hidden = YES;
        [_commitBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }
}
@end
