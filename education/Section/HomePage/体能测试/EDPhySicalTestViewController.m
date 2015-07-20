//
//  EDPhySicalTestViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhySicalTestViewController.h"
#import "SETabBarViewController.h"
#import "EDGradeRecodeCell.h"
#import "EDPhysicalDetailViewController.h"

@interface EDPhySicalTestViewController ()
{
    SETabBarViewController *tabBarView;
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDPhySicalTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"体质体能";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self AFNRequest];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)AFNRequest
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
    
    NSLog(@"学生ID--%@",[SEUtils getUserInfo].UserDetail.studentInfo.ID);
    NSDictionary *pramaters;
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3) {
        //老师
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"XSID":[SEUtils getUserInfo].UserDetail.studentInfo.ID
                     };
    }else
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"XSID":@""};
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@StudentHealth",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
          
            dataArray = responseObject[@"data"];
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
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDGradeRecodeCell *physicalCell = [tableView dequeueReusableCellWithIdentifier:@"recode"];
    if (physicalCell == nil) {
        physicalCell = [[[NSBundle mainBundle]loadNibNamed:@"EDGradeRecodeCell" owner:self options:nil]lastObject];
    }
    return physicalCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhysicalDetailViewController *physicalDetailVC = [[EDPhysicalDetailViewController alloc]init];
    [self.navigationController pushViewController:physicalDetailVC animated:YES];
}

@end
