//
//  EDChooseStudentsViewController.m
//  education
//
//  Created by Apple on 15/7/26.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDChooseStudentsViewController.h"
#import "EDContactContentCell.h"
#import "EDPhySicalTestViewController.h"
#import "EDGradeRecodeViewController.h"
#import "EDPhySicalTestViewController.h"
#import "ChineseString.h"
#import <UIImageView+WebCache.h>
#import "GrowthTrailViewController.h"

@interface EDChooseStudentsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *stuTitleArray;
    NSMutableArray *studentArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@end

@implementation EDChooseStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择学生";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    _nonDataLabel.hidden = YES;
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    

    [self AFNRequest];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hiddenView
{
    _msgView.hidden = YES;
}

- (NSMutableArray *)getPaixuArray:(NSMutableArray *)titleArray dataArray:(NSArray *)dataArray
{
    NSMutableArray *item = [NSMutableArray array];
    NSMutableArray *stumuableArray = [NSMutableArray array];
    
    for (int j=0; j<titleArray.count; j++)
    {
        item = [NSMutableArray array];
        for (int i=0;i<dataArray.count;i++)
        {
            if ([dataArray[i][@"SZM"] isEqualToString:titleArray[j]]) {
                //
                [item  addObject:dataArray[i]];
                //
            }
        }
        [stumuableArray addObject:item];
        
    }
    //    NSLog(@"array-----5%@",stumuableArray);
    return stumuableArray;
}

- (void)AFNRequest
{
    NSLog(@"tea---%@",[SEUtils getUserInfo].UserDetail.teacherInfo);
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                               @"BJID":_classId};
    
    NSString *urlString = [NSString stringWithFormat:@"%@GradeClassStu",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject[@"data"]);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            
            if (responseObject[@"data"] == [NSNull null])
            {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
            }else
            {
                NSArray *stuDataArray = responseObject[@"data"];
                NSMutableArray *stuNameArray = [NSMutableArray array];
                for (int i=0; i<stuDataArray.count; i++) {
                    [stuNameArray addObject:stuDataArray[i][@"XSXM"]];
                }
                stuTitleArray = [ChineseString IndexArray:stuNameArray];
                studentArray = [self getPaixuArray:stuTitleArray dataArray:stuDataArray];
                
                
                [_tableView reloadData];
            }
            
            
            
            
        }else
        {
            _msgView.hidden = NO;
            _msgLabel.text = responseObject[@"responseMessage"];
            [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return stuTitleArray.count;
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [studentArray[section] count];
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
    UILabel *head = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 50, 15)];
    head.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:1/255.0f alpha:1.0];
    head.font = [UIFont systemFontOfSize:14];
   
    head.text = stuTitleArray[section];
   
    
    
    [view addSubview:head];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDContactContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDContactContentCell" owner:self options:nil]lastObject];
    }
     contentCell.name.text = studentArray[indexPath.section][indexPath.row][@"XSXM"];
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,studentArray[indexPath.section][indexPath.row][@"YHTX"]];
        NSURL *url = [NSURL URLWithString:imgString];
        [contentCell.contactImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
        
        if(indexPath.row == [studentArray[indexPath.section] count]-1)
        {
            contentCell.lineView.hidden = YES;
        }
    
    
    
    return contentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([_type isEqualToString:@"成绩档案"])
    {
        EDGradeRecodeViewController *gradeVC = [[EDGradeRecodeViewController alloc]init];
        gradeVC.detailId = studentArray[indexPath.section][indexPath.row][@"XSID"];
        [self.navigationController pushViewController:gradeVC animated:YES];
        
    }else if ([_type isEqualToString:@"体质体能"]){
        EDPhySicalTestViewController *physicalVC = [[EDPhySicalTestViewController alloc]init];
        physicalVC.detailId = studentArray[indexPath.section][indexPath.row][@"XSID"];
        [self.navigationController pushViewController:physicalVC animated:YES];
    }else
    {
        //成长足迹
        GrowthTrailViewController *growthVC = [[GrowthTrailViewController alloc]init];
        growthVC.detailId = studentArray[indexPath.section][indexPath.row][@"XSID"];
        [self.navigationController pushViewController:growthVC animated:YES];

        
    }
    
    
    
    
    
    
}

@end
