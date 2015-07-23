//
//  EDTeacherInfoViewController.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDTeacherInfoViewController.h"
#import "SETabBarViewController.h"
#import "EDSendMsgViewController.h"
#import <UIImageView+WebCache.h>

@interface EDTeacherInfoViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation EDTeacherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"教师信息";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)drawlayer
{
    _headImg.layer.cornerRadius = 4.0f;
    _headImg.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 4.0f;
    _sendBtn.layer.masksToBounds = YES;
    
    _location.text = _detailDic[@"QYMC"];
    _school.text = _detailDic[@"DWMC"];
    _name.text = _detailDic[@"JSXM"];
    _subject.text = _detailDic[@"RJXK"];
    _profession.text = _detailDic[@"SRZW"];
    
}
- (IBAction)sendMsgBtn:(id)sender {
    EDSendMsgViewController *sendMsgVC = [[EDSendMsgViewController alloc]init];
    sendMsgVC.detailId = _detailDic[@"UID"];
    [self.navigationController pushViewController:sendMsgVC animated:YES];
}
@end
