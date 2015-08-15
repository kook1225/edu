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
#import "ClassCircleViewController.h"
#import "EDChooseStudentsViewController.h"
#import "EDClassOnlineViewController.h"

@interface EDSubjectViewController ()
{
    SETabBarViewController *tabBarView;
    NSArray *grdArray;
    NSArray *subArray;
    NSMutableArray *grdSelected;
    NSMutableArray *subSelected;
    NSString *nianji;
   
}
@property (weak, nonatomic) IBOutlet UITableView *gradeTableView;
@property (weak, nonatomic) IBOutlet UITableView *subjectTableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel2;
@end

@implementation EDSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    grdSelected = [NSMutableArray array];
    subSelected = [NSMutableArray array];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    [self AFNRequest:3 class:nil];
    
    _nonDataLabel.hidden = YES;
    _nonDataLabel2.hidden = YES;
    
    
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
    HUD.labelText = @"加载中...";
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
                if (responseObject[@"data"] == [NSNull null]) {
                    _nonDataLabel.hidden = NO;
                    _gradeTableView.hidden = YES;
                }else
                {
                    _nonDataLabel.hidden = YES;
                    _gradeTableView.hidden = NO;
                    grdArray = responseObject[@"data"];
                    [_gradeTableView reloadData];
                }

               
                
            }else if(num == 2)
            {
                if (responseObject[@"data"] == [NSNull null]) {
                    _nonDataLabel2.hidden = NO;
                    _subjectTableView.hidden = YES;
                }else
                {
                    _nonDataLabel2.hidden = YES;
                    _subjectTableView.hidden = NO;
                    subArray = responseObject[@"data"];
                    [_subjectTableView reloadData];
                }
                
            }else
            {
                if (responseObject[@"data"] == [NSNull null]) {
                    _nonDataLabel.hidden = NO;
                    _gradeTableView.hidden = YES;
                }else
                {
                    _nonDataLabel.hidden = YES;
                    _gradeTableView.hidden = NO;
                    grdArray = responseObject[@"data"];
                    [_gradeTableView reloadData];
                    [self AFNRequest:2 class:grdArray[0][@"NJID"]];
                }

                
            }
            
            nianji = grdArray[0][@"NJMC"];
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
        
        gradeCell.grade.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        if(grdSelected.count !=0)
        {
            if ([grdSelected[0]  intValue] == indexPath.row)
            {
                gradeCell.grade.textColor = [UIColor redColor];
            }
        }
        
        gradeCell.grade.text = grdArray[indexPath.row][@"NJMC"];
        
        return gradeCell;
    }else
    {
        EDSubjectCell *subCell = [tableView dequeueReusableCellWithIdentifier:@"subject"];
        if (subCell == nil) {
            subCell = [[[NSBundle mainBundle]loadNibNamed:@"EDSubjectCell" owner:self options:nil]lastObject];
        }
        subCell.subject.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        if(subSelected.count !=0)
        {
            if ([subSelected[0]  intValue] == indexPath.row)
            {
                subCell.subject.textColor = [UIColor redColor];
            }
        }
        subCell.subject.text = subArray[indexPath.row][@"BJMC"];
        return subCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _gradeTableView) {
       
        [grdSelected removeAllObjects];
        NSString *selectNum = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
       
        [grdSelected addObject:selectNum];
        
        [_gradeTableView reloadData];
      
        nianji = grdArray[indexPath.row][@"NJMC"];
        [self  AFNRequest:2 class:grdArray[indexPath.row][@"NJID"]];
        
    }else
    {
        
       if ([_type isEqualToString:@"家庭作业"])
       {
           EDHomeWorkViewController *homeWorkVC = [[EDHomeWorkViewController alloc]init];
           homeWorkVC.detailId = subArray[indexPath.row][@"BJID"];
           homeWorkVC.nianji = nianji;
           homeWorkVC.banji = subArray[indexPath.row][@"BJMC"];
           [self.navigationController pushViewController:homeWorkVC animated:YES];
       }else if ([_type isEqualToString:@"我的课表"])
       {
           SchoolTimeTableViewController *schoolTimeVC = [[SchoolTimeTableViewController alloc]init];
           schoolTimeVC.detailId = subArray[indexPath.row][@"BJID"];
           schoolTimeVC.nianji = nianji;
           schoolTimeVC.banji = subArray[indexPath.row][@"BJMC"];;
           [self.navigationController pushViewController:schoolTimeVC animated:YES];
           
       }
       else if ([_type isEqualToString:@"成绩档案"])
       {
           //要选择学生
           EDChooseStudentsViewController *chooseStuVC = [[EDChooseStudentsViewController alloc]init];
           chooseStuVC.classId = subArray[indexPath.row][@"BJID"];
           chooseStuVC.type = @"成绩档案";
           [self.navigationController pushViewController:chooseStuVC animated:YES];
       }else if ([_type isEqualToString:@"体质体能"])
       {
           //要选择学生
          
           EDChooseStudentsViewController *chooseStuVC = [[EDChooseStudentsViewController alloc]init];
           chooseStuVC.classId = subArray[indexPath.row][@"BJID"];
           chooseStuVC.type = @"体质体能";
           [self.navigationController pushViewController:chooseStuVC animated:YES];
       }else if ([_type isEqualToString:@"成长足迹"])
       {
           //要选择学生
           EDChooseStudentsViewController *chooseStuVC = [[EDChooseStudentsViewController alloc]init];
           chooseStuVC.classId = subArray[indexPath.row][@"BJID"];
           chooseStuVC.type = @"成长足迹";
           [self.navigationController pushViewController:chooseStuVC animated:YES];
       }
       else
       {
           ClassCircleViewController *classCircleVC = [[ClassCircleViewController alloc]init];
           classCircleVC.detailId = subArray[indexPath.row][@"BJID"];
           [self.navigationController pushViewController:classCircleVC animated:YES];
           
       }
//        [subSelected removeAllObjects];
//        NSString *selectNum = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//        
//        [subSelected addObject:selectNum];
//        [_subjectTableView  reloadData];
    }

}

@end
