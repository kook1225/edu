//
//  EDClassOnlineViewController.m
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDClassOnlineViewController.h"
#import "SETabBarViewController.h"

@interface EDClassOnlineViewController ()
{
    SETabBarViewController *tabBarView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EDClassOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"在线课堂";
    
    self.navigationItem.leftBarButtonItem = [Tools  getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView  =  (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
