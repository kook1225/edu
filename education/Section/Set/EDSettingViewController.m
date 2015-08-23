//
//  EDSettingViewController.m
//  education
//
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDSettingViewController.h"
#import "SETabBarViewController.h"
#import "EDSetProblemViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"

@interface EDSettingViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UIView *systemView;
@end

@implementation EDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    
    _systemView.hidden = YES;
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [tabBarView tabBarViewShow];
    
}

#pragma mark TAP
- (IBAction)contactUsTap:(id)sender {
    //联系我们
//    ContactUsViewController *contactUsVC = [[ContactUsViewController alloc] init];
//    [self.navigationController pushViewController:contactUsVC animated:YES];
    NSString *tel = @"telprompt://96255";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}
- (IBAction)problemTap:(id)sender {
    //问题反馈
    EDSetProblemViewController *setProblemVC = [[EDSetProblemViewController alloc]init];
    [self.navigationController pushViewController:setProblemVC animated:YES];
}

- (IBAction)aboutUsTap:(id)sender {
    //关于我们
    AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
}

@end
