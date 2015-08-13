//
//  PayEndViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "PayEndViewController.h"

@interface PayEndViewController ()
@property (weak, nonatomic) IBOutlet UIButton *seeOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end

@implementation PayEndViewController

- (void)viewDidLoad {
    self.title = @"支付结果";
    
    _seeOrderBtn.layer.cornerRadius = 5.0f;
    
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBarBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
    
    if ([_typeName  isEqual: @"VIP优惠包"]) {
        _introLabel.text = @"恭喜，VIP开通成功！";
        [self userInfo];
    }
    
}

#pragma mark - Custom Method
- (void)backBtn {
    NSLog(@"隐藏按钮");
}

- (void)userInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@MyInfo",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSError *err;
             
             UserModel *model = [[UserModel alloc] initWithDictionary:responseObject[@"data"] error:&err];
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 
                 [SEUtils setUserInfo:model];
             }
             else {
                 SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if(error.code == -1001)
             {
                 SHOW_ALERT(@"提示", @"网络请求超时");
             }else if (error.code == -1009)
             {
                 SHOW_ALERT(@"提示", @"网络连接已断开");
             }
         }];
}


- (IBAction)seeOrderBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayEndViewController"
                                                        object:@"popOrderList"
                                                      userInfo:@{}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
