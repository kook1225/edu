//
//  EDNoticeViewController.m
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDNoticeViewController.h"
#import "SETabBarViewController.h"
#import "EDDayInfoCell.h"

@interface EDNoticeViewController ()
{
    SETabBarViewController  *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通知公告";
    
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EDDayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EDDayInfoCell" owner:self options:nil]lastObject];
    }
    [cell setdata];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
