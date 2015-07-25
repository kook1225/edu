//
//  EDClassOnlineViewController.m
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDClassOnlineViewController.h"
#import "SETabBarViewController.h"
#import "EDClassOnlineCell.h"

@interface EDClassOnlineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SETabBarViewController *tabBarView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDClassOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.leftBarButtonItem = [Tools  getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView  =  (SETabBarViewController *)self.navigationController.parentViewController;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDClassOnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vodie"];
    if (cell== nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EDClassOnlineCell" owner:self options:nil]lastObject];
    }
    return cell;
}
@end
