//
//  AboutUsViewController.m
//  education
//
//  Created by zhujun on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SETabBarViewController.h"

@interface AboutUsViewController ()<UIWebViewDelegate>
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token};
    NSString *urlString = [NSString stringWithFormat:@"%@AboutUs",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
         
            
            NSString *path_1 = [[NSBundle mainBundle] pathForResource:@"details" ofType:@"html"];
            NSString *string_1 = [[NSString alloc]initWithContentsOfFile:path_1 encoding:NSUTF8StringEncoding error:nil]; //设置内容
            NSString *newContent_1 = [string_1 stringByReplacingOccurrencesOfString:@"${content}" withString:responseObject[@"data"]];
            [_webView loadHTMLString:newContent_1 baseURL:[[NSBundle mainBundle] bundleURL]];
            _webView.scrollView.scrollEnabled = NO;
            
            
            
        }else
        {
            SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD setHidden:YES];
        if (operation.response.statusCode == 401) {
            NSLog(@"请求超时");
            //   [SEUtils repetitionLogin];
        }else if(error.code == -1001)
        {
            SHOW_ALERT(@"提示", @"网络请求超时");
        }else if (error.code == -1009)
        {
            SHOW_ALERT(@"提示", @"网络连接已断开");
        }
        else {
            NSLog(@"Error:%@",error);
            NSLog(@"err:%@",operation.responseObject[@"message"]);
            //   SHOW_ALERT(@"提示",operation.responseObject[@"message"])
        }
    }];

}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
