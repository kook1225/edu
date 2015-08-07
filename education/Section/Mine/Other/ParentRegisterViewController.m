//
//  ParentRegisterViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ParentRegisterViewController.h"
#import "FillInforViewController.h"

@interface ParentRegisterViewController ()<FillInforViewControllerDelegate> {
    NSString *password;
}
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *surePwd;

@end

@implementation ParentRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家长注册";
    
    _nextBtn.layer.cornerRadius = 5.0f;
    _nextBtn.layer.masksToBounds = YES;
    //password = [SecurityUtil encryptMD5String:_pwd.text];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)nextBtn:(id)sender {
    if ([_userName.text  isEqual: @""]) {
        SHOW_ALERT(@"提示", @"手机号码不能为空");
    }
    else {
        if ([_pwd.text isEqual:@""] || [_surePwd.text isEqual:@""]) {
            SHOW_ALERT(@"提示", @"密码不能为空");
        }
        else {
            
            if (!(([_pwd.text length] >= 6 && [_pwd.text length] <= 20) && ([_surePwd.text length] >= 6 && [_surePwd.text length] <= 20))) {
                SHOW_ALERT(@"提示", @"密码长度不正确");
            }
            else {
                if (![_pwd.text isEqualToString: _surePwd.text]) {
                    SHOW_ALERT(@"提示", @"两次密码不一致");
                }
                else {
                    FillInforViewController *fillIntroVC = [[FillInforViewController alloc] init];
                    fillIntroVC.userName = _userName.text;
                    fillIntroVC.pwd = _pwd.text;
                    fillIntroVC.delegate = self;
                    [self.navigationController pushViewController:fillIntroVC animated:YES];
                }
            }
            
        }
    }
}

#pragma mark - FillInforViewControllerDelegate Method 
- (void)Login {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
