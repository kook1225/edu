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

@interface EDContactViewController ()
{
    SETabBarViewController *tabBarView;
    NSMutableArray *teaTitleArrray;
//    NSMutableArray *stuTitleArray;
    NSMutableArray *teacherArray;
//    NSMutableArray *studentArray;
    NSString *typeString;
    
   
}
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property(nonatomic,retain)NSMutableArray *stuTitleArray;
@property(nonatomic,retain)NSMutableArray *studentArray;
@end

@implementation EDContactViewController
@synthesize stuTitleArray;
@synthesize studentArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    
    teaTitleArrray = [NSMutableArray array];
    stuTitleArray = [NSMutableArray array];
    teacherArray = [NSMutableArray array];
    studentArray = [NSMutableArray array];
    
    [self drawlayer];
//    NSArray *array1 = @[@"asdd",@"haha",@"阿什",@"知道"];
    //            responseObject[@"data"][@"classContacts"][0][@"students"];
//    stuTitleArray = [ChineseString IndexArray:array1];
//    studentArray = [ChineseString LetterSortArray:array1];
    [self AFNRequest];
    typeString = @"学生";
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
- (void)AFNRequest
{
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token};
   
    NSString *urlString = [NSString stringWithFormat:@"%@Contacts",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject[@"data"]);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            NSArray *teaNameArray = responseObject[@"data"][@"classContacts"][0][@"teachers"];
            NSMutableArray *teaArray = [NSMutableArray array];
            for (int i=0; i<teaNameArray.count; i++) {
                [teaArray addObject:teaNameArray[i][@"JSXM"]];
            }
            
           teaTitleArrray = [ChineseString IndexArray:teaArray];
            teacherArray = [ChineseString LetterSortArray:teaArray];

            NSArray *stuNameArray = responseObject[@"data"][@"classContacts"][0][@"students"];
            NSMutableArray *stuArray = [NSMutableArray array];
            for (int i=0; i<stuNameArray.count; i++) {
                [stuArray addObject:stuNameArray[i][@"XSXM"]];
            }
            stuTitleArray = [ChineseString IndexArray:stuArray];
            studentArray = [ChineseString LetterSortArray:stuArray];
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

- (void)drawlayer
{
    _buttonView.layer.cornerRadius = 4.0f;
    _buttonView.layer.masksToBounds = YES;
    _buttonView.layer.borderWidth = 1.0f;
    _buttonView.layer.borderColor = [UIColor colorWithRed:255/255.0f green:124/255.0f  blue:6/255.0f  alpha:1.0f].CGColor;
    
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
        return teacherArray.count;
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
        contentCell.name.text = [[studentArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        NSLog(@"------%@",[studentArray objectAtIndex:indexPath.section]);
//        if(indexPath.row == studentArray.count-1)
//        {
//            contentCell.lineView.hidden = YES;
//        }
    }else
    {
        contentCell.name = [[teacherArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        if(indexPath.row == teacherArray.count-1)
//        {
//            contentCell.lineView.hidden = YES;
//        }
    }
    
    
    return contentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EDTeacherInfoViewController *teacherVC = [[EDTeacherInfoViewController alloc]init];
//    [self.navigationController pushViewController:teacherVC animated:YES];
    
    EDStudentViewController *studentVC = [[EDStudentViewController alloc]init];
    [self.navigationController pushViewController:studentVC animated:YES];
}
@end
