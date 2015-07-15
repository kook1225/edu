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
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)drawlayer
{
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitBtn.layer.masksToBounds = YES;
}

- (IBAction)commitFunction:(id)sender {
    if ([_oldPwdTextField.text length] == 0 || [_nowPwdTextField.text length] == 0 || [_surePwdTextField.text length] == 0 ) {
        SHOW_ALERT(@"提示", @"密码不能为空");
    }
    else {
        if (![_surePwdTextField.text isEqualToString: _nowPwdTextField.text]) {
            SHOW_ALERT(@"提示", @"两次密码不一致");
        }
        else {
            /*
            _commitBtn.enabled = NO;
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"Loading";
            HUD.removeFromSuperViewOnHide = YES;
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@Password",SERVER_HOST];
            
            NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"password1":_oldPwdTextField.text,@"password2":_nowPwdTextField.text};
            
            [manager POST:urlStr parameters:parameter
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      _commitBtn.enabled = YES;
                      [HUD hide:YES];
                      
                      if ([responseObject[@"responseCode"] intValue] == 0) {
                          
                      }
                      else {
                          SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                      }
                      
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      _commitBtn.enabled = YES;
                      [HUD hide:YES];
                      if (operation.response.statusCode == 401) {
                          NSLog(@"请求超时");
                          //   [SEUtils repetitionLogin];
                      }
                      else {
                          NSLog(@"Error:%@",error);
                          NSLog(@"err:%@",operation.responseObject[@"message"]);
                          //   SHOW_ALERT(@"提示",operation.responseObject[@"message"])
                      }
                  }];
             */
        }
    }
}

@end
