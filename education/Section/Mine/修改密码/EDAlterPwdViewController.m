//
//  EDAlterPwdViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDAlterPwdViewController.h"
#import "SETabBarViewController.h"

@interface EDAlterPwdViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *surePwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation EDAlterPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    [self drawlayer];
}
#pragma mark 常用方法
- (void)back
{
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)drawlayer
{
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitBtn.layer.masksToBounds = YES;
}

- (IBAction)commitFunction:(id)sender {
}

@end
