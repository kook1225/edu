//
//  EDPhySicalTestViewController.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhySicalTestViewController.h"
#import "SETabBarViewController.h"
#import "EDGradeRecodeCell.h"
#import "EDPhysicalDetailViewController.h"

@interface EDPhySicalTestViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDPhySicalTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"体质体能";
    
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
    EDGradeRecodeCell *physicalCell = [tableView dequeueReusableCellWithIdentifier:@"recode"];
    if (physicalCell == nil) {
        physicalCell = [[[NSBundle mainBundle]loadNibNamed:@"EDGradeRecodeCell" owner:self options:nil]lastObject];
    }
    return physicalCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDPhysicalDetailViewController *physicalDetailVC = [[EDPhysicalDetailViewController alloc]init];
    [self.navigationController pushViewController:physicalDetailVC animated:YES];
}

@end
