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
#import "EDAlterPwdViewController.h"

@interface LoginViewController () {
    NSString *deviceId;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    
    NSUUID *deviceUID = [device identifierForVendor];
    
    deviceId = [NSString stringWithFormat:@"%@",deviceUID.UUIDString];
    
    NSLog(@"设备id:%@",deviceId); // 输出设备id
    
    _loginBtn.layer.cornerRadius = 4.0f;
}

#pragma mark 按钮功能
- (IBAction)loginFunction:(id)sender {
    if ([_userName.text length] == 0 || [_userPwd.text length] == 0) {
        SHOW_ALERT(@"提示", @"用户名或密码不能为空");
    }
    else {
        if (![SEUtils isValidateMobile:_userName.text]) {
            SHOW_ALERT(@"提示", @"用户名格式不正确");
        }
        else {
            if (!([_userPwd.text length] >= 6 && [_userPwd.text length] <= 20)) {
                SHOW_ALERT(@"提示", @"密码长度不正确");
            }
            else {
                
                _loginBtn.enabled = NO;
                
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.mode = MBProgressHUDModeIndeterminate;
                HUD.labelText = @"Loading";
                HUD.removeFromSuperViewOnHide = YES;
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@Token",SERVER_HOST];
                
                NSDictionary *parameter = @{@"registerId":deviceId,@"username":_userName.text,@"password":_userPwd.text,@"deviceType":@"4"};
                
                [manager POST:urlStr parameters:parameter
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          _loginBtn.enabled = YES;
                          [HUD hide:YES];
                          
                          NSError *err;
                          
                          UserModel *model = [[UserModel alloc] initWithDictionary:responseObject[@"data"] error:&err];
                          
                          if ([responseObject[@"responseCode"] intValue] == 0) {
                              [SEUtils setUserInfo:model];
                              
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
                          else {
                              SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                          }
                          
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          _loginBtn.enabled = YES;
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
            }
        }
    }
}
- (IBAction)findPwdFunction:(id)sender {
    EDAlterPwdViewController *edAlertPwdVC = [[EDAlterPwdViewController alloc] init];
    edAlertPwdVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:edAlertPwdVC];
    [self presentViewController:nav animated:YES completion:nil];

}

- (IBAction)registerFunction:(id)sender {
    ParentRegisterViewController *parentRegisterVC = [[ParentRegisterViewController alloc] init];
    parentRegisterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:parentRegisterVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
