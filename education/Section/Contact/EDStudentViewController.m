//
//  EDStudentViewController.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDStudentViewController.h"
#import "SETabBarViewController.h"
#import "EDSendMsgViewController.h"

@interface EDStudentViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EDStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"学生信息";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 950);
    
}
#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendMsgBtn:(id)sender {
    EDSendMsgViewController *sendMsgVC = [[EDSendMsgViewController alloc]init];
    [self.navigationController pushViewController:sendMsgVC animated:YES];
}


@end
