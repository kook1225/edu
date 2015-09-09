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
    BOOL vipUser;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //隐藏注册
    _registerBtn.hidden = YES;
    
    // 获取设备id
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSUUID *deviceUID = [device identifierForVendor];
    deviceId = [NSString stringWithFormat:@"%@",deviceUID.UUIDString];
    
    _userName.placeholder = @"请输入您的账号";
    [_userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_userName setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    _userPwd.placeholder = @"请输入您的密码";
    [_userPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_userPwd setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    if ([SEUtils getUserInfo]) {
        _userName.text = [[[[SEUtils getUserInfo] UserDetail] userinfo] YHM];
    }
   
    _loginBtn.layer.cornerRadius = 4.0f;
}



#pragma mark 按钮功能
- (IBAction)loginFunction:(id)sender {
    if ([_userName.text length] == 0 || [_userPwd.text length] == 0) {
        SHOW_ALERT(@"提示", @"用户名或密码不能为空");
    }
    else {
        if (!([_userPwd.text length] >= 6 && [_userPwd.text length] <= 20)) {
            SHOW_ALERT(@"提示", @"密码长度不正确");
        }
        else {
            
            _loginBtn.enabled = NO;
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            HUD.labelText = @"加载中...";
            HUD.removeFromSuperViewOnHide = YES;
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@Token",SERVER_HOST];
            
            NSDictionary *parameter = @{@"registerId":deviceId,@"username":_userName.text,@"password":_userPwd.text,@"deviceType":@"4"};
            
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager POST:urlStr parameters:parameter
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      _loginBtn.enabled = YES;
                      [HUD hide:YES];
                      
                      NSError *err;
                      
                      UserModel *model = [[UserModel alloc] initWithDictionary:responseObject[@"data"] error:&err];
                      
                      if ([responseObject[@"responseCode"] intValue] == 0) {
                          [SEUtils setUserInfo:model];
                          [self goHomeWork];
                      }
                      else {
                          SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                      }
                      
                      
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      _loginBtn.enabled = YES;
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


- (IBAction)registerFunction:(id)sender {
    ParentRegisterViewController *parentRegisterVC = [[ParentRegisterViewController alloc] init];
    parentRegisterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:parentRegisterVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)goHomeWork {
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

@end
