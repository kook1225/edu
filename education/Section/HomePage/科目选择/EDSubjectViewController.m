//
//  EDSubjectViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDSubjectViewController.h"
#import "EDGradeCell.h"
#import "EDSubjectCell.h"
#import "SETabBarViewController.h"

@interface EDSubjectViewController ()
{
    SETabBarViewController *tabBarView;
    NSArray *grdArray;
    NSArray *subArray;
}
@property (weak, nonatomic) IBOutlet UITableView *gradeTableView;
@property (weak, nonatomic) IBOutlet UITableView *subjectTableView;
@end

@implementation EDSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择科目";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    grdArray = @[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"];
    subArray = @[@"语文",@"数学",@"英语",@"思想政治"];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
}

#pragma mark 常用方
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)AFNRequest
{
//    dataArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSLog(@"类型--%@",[SEUtils getUserInfo].UserDetail.userinfo.YHLB);
    NSDictionary *pramaters;
    //    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3) {
    //老师
    pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                 @"type":@"1",
                 @"page":@"1",
                 @"pagesize":@"10",
                 @"ceci":@"",
                 @"xueke":@"",
                 @"pushtime":@"",
                 @"V_type":@""
                 };
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@EduOnlineList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            
            
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
    if (tableView == _gradeTableView) {
        return 6;
    }else
    {
        return 4;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _gradeTableView) {
        return 55;
    }else
    {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == _gradeTableView) {
        EDGradeCell *gradeCell = [tableView dequeueReusableCellWithIdentifier:@"grade"];
        if (gradeCell == nil) {
            gradeCell = [[[NSBundle mainBundle]loadNibNamed:@"EDGradeCell" owner:self options:nil]lastObject];
        }
        return gradeCell;
    }else
    {
        EDSubjectCell *subCell = [tableView dequeueReusableCellWithIdentifier:@"subject"];
        if (subCell == nil) {
            subCell = [[[NSBundle mainBundle]loadNibNamed:@"EDSubjectCell" owner:self options:nil]lastObject];
        }
        return subCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
