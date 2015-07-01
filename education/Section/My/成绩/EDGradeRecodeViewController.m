//
//  EDGradeRecodeViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGradeRecodeViewController.h"
#import "EDGradeRecodeCell.h"
#import "EDGradeDetailViewController.h"
#import "SETabBarViewController.h"

@interface EDGradeRecodeViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDGradeRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"成绩档案";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
}


#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDGradeRecodeCell *recodeCell = [tableView dequeueReusableCellWithIdentifier:@"recodeCell"];
    if (recodeCell == nil) {
        recodeCell = [[[NSBundle mainBundle]loadNibNamed:@"EDGradeRecodeCell" owner:self options:nil]lastObject];
    }
    return recodeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDGradeDetailViewController *gradeDetailVC = [[EDGradeDetailViewController alloc]init];
    [self.navigationController pushViewController:gradeDetailVC animated:YES];
}

@end
