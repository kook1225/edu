//
//  EDContactViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDContactViewController.h"
#import "EDContactContentCell.h"
#import "EDTeacherInfoViewController.h"
#import "EDStudentViewController.h"
#import "SETabBarViewController.h"
#import "ChineseString.h"
#import <UIImageView+WebCache.h>

@interface EDContactViewController ()
{
    SETabBarViewController *tabBarView;
    NSMutableArray *teaTitleArrray;
    NSMutableArray *stuTitleArray;
    NSMutableArray *teacherArray;
    NSMutableArray *studentArray;
    
    NSString *typeString;
    
   
}
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentBtn;

@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation EDContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    

    
    teaTitleArrray = [NSMutableArray array];
    stuTitleArray = [NSMutableArray array];
    teacherArray = [NSMutableArray array];
    studentArray = [NSMutableArray array];
    
    _nonDataLabel.hidden = YES;
    typeString = @"学生";
    [self drawlayer];
    [self AFNRequest];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewShow];
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

- (void)AFNRequest
{
    NSLog(@"tea---%@",[SEUtils getUserInfo].UserDetail.teacherInfo);
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token};
   
    NSString *urlString = [NSString stringWithFormat:@"%@Contacts",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject[@"data"]);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            if (responseObject[@"data"][@"teachers"] == [NSNull null]
                || responseObject[@"data"][@"students"] == [NSNull null])
            {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
                
            }else
            {
                NSArray *teaDataArray = responseObject[@"data"][@"teachers"];
                NSMutableArray *teaNameArray = [NSMutableArray array];
                for (int i=0; i<teaDataArray.count; i++) {
                    [teaNameArray addObject:teaDataArray[i][@"JSXM"]];
                }
                
                teaTitleArrray = [ChineseString IndexArray:teaNameArray];
                teacherArray = [self getPaixuArray:teaTitleArrray dataArray:teaDataArray];
                
                
                NSArray *stuDataArray = responseObject[@"data"][@"students"];
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

- (void)drawlayer
{
    _buttonView.layer.cornerRadius = 4.0f;
    _buttonView.layer.masksToBounds = YES;
    _buttonView.layer.borderWidth = 1.0f;
    _buttonView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:124/255.0f  blue:6/255.0f  alpha:1.0f].CGColor;
    
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    
    [_studentBtn setSelected:YES];
}

#pragma mark 按钮
- (IBAction)userBtnFunction:(id)sender {
    [_userBtn setSelected:YES];
    [_studentBtn setSelected:NO];
    typeString = @"用户";
    [_tableView reloadData];
}

- (IBAction)studentBtnFunction:(id)sender {
    [_userBtn setSelected:NO];
    [_studentBtn setSelected:YES];
    typeString = @"学生";
    [_tableView reloadData];
}

#pragma mark tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([typeString isEqualToString:@"学生"])
    {
        return stuTitleArray.count;
    }else
    {
        return teaTitleArrray.count;
    }

   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([typeString isEqualToString:@"学生"])
    {
        return [[studentArray objectAtIndex:section] count];
    }else
    {
        return [teacherArray[section] count];
    }
 
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
    if ([typeString isEqualToString:@"学生"])
    {
         head.text = stuTitleArray[section];
    }else
    {
        head.text = teaTitleArrray[section];
    }

   
    [view addSubview:head];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDContactContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDContactContentCell" owner:self options:nil]lastObject];
    }
    if ([typeString isEqualToString:@"学生"])
    {
        if([studentArray[indexPath.section][indexPath.row][@"IsVip"] intValue] ==1)
        {
            contentCell.name.textColor = [UIColor redColor];
        }
        contentCell.name.text = studentArray[indexPath.section][indexPath.row][@"XSXM"];
        
        NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,studentArray[indexPath.section][indexPath.row][@"YHTX"]];
        NSURL *url = [NSURL URLWithString:imgString];
        [contentCell.contactImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
        
        if(indexPath.row == [studentArray[indexPath.section] count]-1)
        {
            contentCell.lineView.hidden = YES;
        }
    }else
    {
        contentCell.name.text = [[teacherArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row][@"JSXM"];
        NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,teacherArray[indexPath.section][indexPath.row][@"YHTX"]];
        NSURL *url = [NSURL URLWithString:imgString];

        [contentCell.contactImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
        
        if(indexPath.row == [teacherArray[indexPath.section] count]-1)
        {
            contentCell.lineView.hidden = YES;
        }
    }
    
    
    return contentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if ([typeString isEqualToString:@"学生"])
     {
         EDStudentViewController *studentVC;
         if (!IOS7_LATER) {
             studentVC = [[EDStudentViewController alloc]initWithNibName:@"EDStudentViewController7.0" bundle:nil];

         }else
         {
             studentVC = [[EDStudentViewController alloc]initWithNibName:@"EDStudentViewController" bundle:nil];
         }
         studentVC.detailDic = studentArray[indexPath.section][indexPath.row];
         [self.navigationController pushViewController:studentVC animated:YES];

         
     }else
     {
         EDTeacherInfoViewController *teacherVC;
         if (!IOS7_LATER) {
             teacherVC = [[EDTeacherInfoViewController alloc]initWithNibName:@"EDTeacherInfoViewController7.0" bundle:nil];
             
         }else
         {
             teacherVC = [[EDTeacherInfoViewController alloc]initWithNibName:@"EDTeacherInfoViewController" bundle:nil];
         }
         teacherVC.detailDic =  teacherArray[indexPath.section][indexPath.row];
         [self.navigationController pushViewController:teacherVC animated:YES];
     }

    
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
@end
