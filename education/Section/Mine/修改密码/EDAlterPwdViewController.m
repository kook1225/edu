//
//  EDAlterPwdViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDAlterPwdViewController.h"
#import "SETabBarViewController.h"

@interface EDAlterPwdViewController ()<UIAlertViewDelegate>
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *surePwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation EDAlterPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    _msgView.hidden = YES;
   
    [self drawlayer];
}
#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hiddenView
{
    _msgView.hidden = YES;
}
- (void)drawlayer
{
    _commitBtn.layer.cornerRadius = 5.0f;
    _commitBtn.layer.masksToBounds = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
   
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
            
            if (!([_nowPwdTextField.text length] >= 6 && [_nowPwdTextField.text length] <= 20)) {
                SHOW_ALERT(@"提示", @"密码长度不符合要求");
            }
            else {
             
                _commitBtn.enabled = NO;
                
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.mode = MBProgressHUDModeIndeterminate;
                HUD.labelText = @"Loading";
                HUD.removeFromSuperViewOnHide = YES;
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@Password",SERVER_HOST];
                
                NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"password1":_oldPwdTextField.text,@"password2":_nowPwdTextField.text};
                
                // 设置超时时间
                [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                manager.requestSerializer.timeoutInterval = 10.f;
                [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                
                [manager POST:urlStr parameters:parameter
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          _commitBtn.enabled = YES;
                          [HUD hide:YES];
                          
                          if ([responseObject[@"responseCode"] intValue] == 0) {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                              alert.tag = 201;
                              [alert show];
                          }
                          else {
                              _msgView.hidden = NO;
                              _msgLabel.text = responseObject[@"responseMessage"];
                              [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];

                          }
                          
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          _commitBtn.enabled = YES;
                          [HUD hide:YES];
                          if(error.code == -1001)
                          {
                              SHOW_ALERT(@"提示", @"网络请求超时");
                          }else if (error.code == -1009)
                          {
                              SHOW_ALERT(@"提示", @"网络连接已断开");
                          }
                      }];
            }
            
        }
    }
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
