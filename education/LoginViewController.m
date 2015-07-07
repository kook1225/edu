//
//  LoginViewController.m
//  education
//
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _loginBtn.layer.cornerRadius = 4.0f;
}

#pragma mark 按钮功能
- (IBAction)loginFunction:(id)sender {
}
- (IBAction)findPwdFunction:(id)sender {
}
- (IBAction)registerFunction:(id)sender {
}

@end
