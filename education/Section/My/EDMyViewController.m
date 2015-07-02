//
//  EDMyViewController.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyViewController.h"
#import "EDGradeRecodeViewController.h"
#import "SETabBarViewController.h"
#import "EDSubjectViewController.h"
#import "EDInfomationViewController.h"

@interface EDMyViewController ()
{
    SETabBarViewController *tabBarView;
}

@end

@implementation EDMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
}

- (void)viewWillAppear:(BOOL)animated
{
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewShow];
}
- (IBAction)gradeBtn:(id)sender {
    EDGradeRecodeViewController *gradeRecodeVC = [[EDGradeRecodeViewController alloc]init];
    [self.navigationController pushViewController:gradeRecodeVC animated:YES];
}
- (IBAction)subjectBtn:(id)sender {
    EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
    [self.navigationController pushViewController:subjectVC animated:YES];
}
- (IBAction)infoBtn:(id)sender {
    EDInfomationViewController *infoVC = [[EDInfomationViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
