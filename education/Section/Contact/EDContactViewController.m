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

@interface EDContactViewController ()
{
    SETabBarViewController *tabBarView;
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentBtn;

@end

@implementation EDContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    
    dataArray = @[@"陈意涵",@"杨洋",@"胡歌"];
    [self drawlayer];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewShow];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (IBAction)studentBtnFunction:(id)sender {
    [_userBtn setSelected:NO];
    [_studentBtn setSelected:YES];
}

#pragma mark tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
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
    head.text = @"A";
    [view addSubview:head];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDContactContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"content"];
    if (contentCell == nil) {
        contentCell = [[[NSBundle mainBundle]loadNibNamed:@"EDContactContentCell" owner:self options:nil]lastObject];
    }
    contentCell.name = dataArray[indexPath.row];
    if(indexPath.row == dataArray.count-1)
    {
        contentCell.lineView.hidden = YES;
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
