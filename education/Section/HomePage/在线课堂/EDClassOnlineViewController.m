//
//  EDClassOnlineViewController.m
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDClassOnlineViewController.h"
#import "SETabBarViewController.h"
#import "EDClassOnlineCell.h"

@interface EDClassOnlineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSMutableArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDClassOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.leftBarButtonItem = [Tools  getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView  =  (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self AFNRequest:_nianji xueke:_xueke];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)AFNRequest:(NSString *)grade xueke:(NSString *)sub
{
    dataArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSLog(@"类型--%@",[SEUtils getUserInfo].TokenInfo.access_token);
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                               @"type":@"3",
                               @"page":@"1",
                               @"pagesize":@"10",
                               @"bjid":@"",
                               @"ceci":grade,
                               @"xueke":sub,
                               @"pushtime":@"",
                               @"V_type":@""
                               };
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@EduOnlineList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            dataArray = responseObject[@"data"][@"list"];
            [_tableView reloadData];
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

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDClassOnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vodie"];
    if (cell== nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EDClassOnlineCell" owner:self options:nil]lastObject];
    }
    return cell;
}
@end
