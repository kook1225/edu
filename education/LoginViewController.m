//
//  LoginViewController.m
//  education
//
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "LoginViewController.h"
#import "EDContactViewController.h"
#import "MineViewController.h"
#import "EDSettingViewController.h"
#import "LoginViewController.h"
#import "SETabBarViewController.h"
#import "ViewController.h"
#import "ParentRegisterViewController.h"

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
    ViewController *viewController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    EDContactViewController *contactVC = [[EDContactViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:contactVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    EDSettingViewController *settingVC = [[EDSettingViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    SETabBarViewController *tabBarVC = [[SETabBarViewController alloc] initWithViewController:@[nav,nav2,nav3,nav4]];
    
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:tabBarVC animated:YES completion:nil];
}
- (IBAction)findPwdFunction:(id)sender {
}
- (IBAction)registerFunction:(id)sender {
    ParentRegisterViewController *parentRegisterVC = [[ParentRegisterViewController alloc] init];
    parentRegisterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:parentRegisterVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
