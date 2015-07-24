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
#import "EDHomeWorkViewController.h"
#import "EDPhySicalTestViewController.h"
#import "SchoolTimeTableViewController.h"
#import "EDGradeRecodeViewController.h"

@interface EDSubjectViewController ()
{
    SETabBarViewController *tabBarView;
    NSArray *grdArray;
    NSArray *subArray;
    BOOL GradeSelected;
    BOOL classSelected;
}
@property (weak, nonatomic) IBOutlet UITableView *gradeTableView;
@property (weak, nonatomic) IBOutlet UITableView *subjectTableView;
@end

@implementation EDSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    if([self.title isEqualToString:@"选择班级"])
    {
        [self AFNRequest:3 class:nil];
    }

    
    
}

#pragma mark 常用方
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)AFNRequest:(int)num class:(NSString *)classId
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
    
    
    NSDictionary *pramaters;
    if(num==1||num==3)
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token};

    }else
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"NJID":classId};

    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@GradeClassStu",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            if (num==1) {
                grdArray = responseObject[@"data"];
                [_gradeTableView reloadData];
                
            }else if(num == 2)
            {
                subArray = responseObject[@"data"];
                [_subjectTableView reloadData];
            }else
            {
                grdArray = responseObject[@"data"];
                [_gradeTableView reloadData];
                [self AFNRequest:2 class:grdArray[0][@"NJID"]];
            }
            
            
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
        return grdArray.count;
    }else
    {
        return subArray.count;
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
        gradeCell.grade.text = grdArray[indexPath.row][@"NJMC"];
        return gradeCell;
    }else
    {
        EDSubjectCell *subCell = [tableView dequeueReusableCellWithIdentifier:@"subject"];
        if (subCell == nil) {
            subCell = [[[NSBundle mainBundle]loadNibNamed:@"EDSubjectCell" owner:self options:nil]lastObject];
        }
        subCell.subject.text = subArray[indexPath.row][@"BJMC"];
        return subCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _gradeTableView) {
//        GradeSelected = YES;
        EDGradeCell *gradeCell = (EDGradeCell *)[tableView cellForRowAtIndexPath:indexPath];
        gradeCell.grade.textColor = [UIColor redColor];
        [_gradeTableView reloadData];
        [self  AFNRequest:2 class:grdArray[indexPath.row][@"NJID"]];

    }else
    {
        
       if ([_type isEqualToString:@"家庭作业"])
       {
           EDHomeWorkViewController *homeWorkVC = [[EDHomeWorkViewController alloc]init];
           homeWorkVC.detailId = subArray[indexPath.row][@"BJID"];
           [self.navigationController pushViewController:homeWorkVC animated:YES];
       }else if ([_type isEqualToString:@"我的课表"])
       {
           SchoolTimeTableViewController *schoolTimeVC = [[SchoolTimeTableViewController alloc]init];
           schoolTimeVC.detailId = subArray[indexPath.row][@"BJID"];
           [self.navigationController pushViewController:schoolTimeVC animated:YES];
           
       }else if ([_type isEqualToString:@"成绩档案"])
       {
           EDGradeRecodeViewController *gradeVC = [[EDGradeRecodeViewController alloc]init];
           gradeVC.detailId = subArray[indexPath.row][@"BJID"];
           [self.navigationController pushViewController:gradeVC animated:YES];
       }else
       {
           //体质体能
           EDPhySicalTestViewController *physicalVC = [[EDPhySicalTestViewController alloc]init];
           physicalVC.detailId = subArray[indexPath.row][@"BJID"];
           [self.navigationController pushViewController:physicalVC animated:YES];
       }
    }

}

@end
