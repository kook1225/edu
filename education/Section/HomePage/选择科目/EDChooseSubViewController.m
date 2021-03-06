//
//  EDChooseSubViewController.m
//  education
//
//  Created by Apple on 15/7/25.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDChooseSubViewController.h"
#import "SETabBarViewController.h"
#import "EDGradeCell.h"
#import "EDSubjectCell.h"
#import "EDClassOnlineViewController.h"
#import "EDProblemAnalyViewController.h"

@interface EDChooseSubViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
    NSArray *grdArray;
    NSArray *subArray;
    NSString *studentId;
    NSString *gradeString;
    
    NSMutableArray *grdSelected;

}
@property (weak, nonatomic) IBOutlet UITableView *gradeTableView;
@property (weak, nonatomic) IBOutlet UITableView *subjectTableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel2;
@end

@implementation EDChooseSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    _nonDataLabel.hidden = YES;
    _nonDataLabel2.hidden = YES;
    
    grdSelected = [NSMutableArray array];
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue]== 3) {
        studentId = @"";
    }else
    {
        studentId = [SEUtils getUserInfo].UserDetail.studentInfo.XSID;
    }
    [self AFNRequest:3 class:nil];
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
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"XSID":studentId};
        
    }else
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"ceci":classId};
        
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@EduOnlineList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            if (num==1) {
                if (responseObject[@"data"] == [NSNull null]) {
                    _nonDataLabel2.hidden = NO;
                    _gradeTableView.hidden = YES;
                }else
                {
                    _nonDataLabel2.hidden = YES;
                    _gradeTableView.hidden = NO;
                    grdArray = responseObject[@"data"];
                    [_gradeTableView reloadData];
                }
                
                
            }else if(num == 2)
            {
                if (responseObject[@"data"]== [NSNull null]) {
                    _nonDataLabel.hidden = NO;
                    _subjectTableView.hidden = YES;
                }else
                {
                    _nonDataLabel.hidden = YES;
                    _subjectTableView.hidden = NO;
                    subArray = responseObject[@"data"];
                    [_subjectTableView reloadData];
                }
                
            }else
            {
                if (responseObject[@"data"] == [NSNull null]) {
                    _nonDataLabel2.hidden = NO;
                    _nonDataLabel.hidden = NO;
                    _gradeTableView.hidden = YES;
                }else
                {
                    _nonDataLabel2.hidden = YES;
                    _nonDataLabel.hidden = YES;
                    _gradeTableView.hidden = NO;
                    grdArray = responseObject[@"data"];
                    [_gradeTableView reloadData];
                    [self AFNRequest:2 class:grdArray[0][@"NJMC"]];
                }

                
            }
            
            gradeString = grdArray[0][@"NJMC"];
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
        subCell.subject.text = subArray[indexPath.row][@"KEMU"];
        return subCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (tableView == _gradeTableView)
        {
            [grdSelected removeAllObjects];
            NSString *selectNum = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            [grdSelected addObject:selectNum];
            
            [_gradeTableView reloadData];
            
        EDGradeCell *gradeCell = (EDGradeCell *)[tableView cellForRowAtIndexPath:indexPath];
        gradeCell.grade.textColor = [UIColor redColor];
        [_gradeTableView reloadData];
        gradeString = grdArray[indexPath.row][@"NJMC"];
        [self  AFNRequest:2 class:grdArray[indexPath.row][@"NJMC"]];
        
    }else
    {
        
        if ([_type isEqualToString:@"在线课堂"])
        {
            EDClassOnlineViewController *classOnlineVC = [[EDClassOnlineViewController alloc]init];
            classOnlineVC.title = [NSString stringWithFormat:@"在线课堂-%@",subArray[indexPath.row][@"KEMU"]];
            
            classOnlineVC.nianji = gradeString;
            classOnlineVC.xueke = subArray[indexPath.row][@"KEMU"];
            [self.navigationController pushViewController:classOnlineVC animated:YES];
            
        }else
        {
            
            EDProblemAnalyViewController *problemAnalyVC = [[EDProblemAnalyViewController alloc]init];
            problemAnalyVC.title = [NSString stringWithFormat:@"难点解析-%@",subArray[indexPath.row][@"KEMU"]];
            problemAnalyVC.nianji = gradeString;
            problemAnalyVC.xueke = subArray[indexPath.row][@"KEMU"];
            [self.navigationController pushViewController:problemAnalyVC animated:YES];
        }
    }
    
}

@end
