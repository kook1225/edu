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
