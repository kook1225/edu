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
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *bornLabel;

@property (weak, nonatomic) IBOutlet UILabel *momName;
@property (weak, nonatomic) IBOutlet UILabel *momPhone;
@property (weak, nonatomic) IBOutlet UILabel *dadName;
@property (weak, nonatomic) IBOutlet UILabel *dadPhone;

@end

@implementation EDStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"学生信息";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
    
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
- (void)drawlayer
{
    _headImg.layer.cornerRadius = 4.0f;
    _headImg.layer.masksToBounds = YES;
//    _sendBtn.layer.cornerRadius = 4.0f;
//    _sendBtn.layer.masksToBounds = YES;
//    
    _location.text = _detailDic[@"QYMC"];
    _school.text = _detailDic[@"DWMC"];
    _grade.text = _detailDic[@"NJMC"];
    _classLabel.text = _detailDic[@"BJMC"];
    _nameLabel.text = _detailDic[@"XSXM"];
    _sexLabel.text = _detailDic[@"XSXB"];
    //    _born.text = _detailDic[@"SRZW"];
    
    _momName.text = _detailDic[@"MQXM"];
    _momPhone.text = _detailDic[@"MQDH"];
    _dadName.text = _detailDic[@"FQXM"];
    _dadPhone.text = _detailDic[@"FQDH"];
    
}
- (IBAction)sendMsgBtn:(id)sender {
    EDSendMsgViewController *sendMsgVC = [[EDSendMsgViewController alloc]init];
    sendMsgVC.detailId = _detailDic[@"UID"];
    sendMsgVC.type = @"1";
    [self.navigationController pushViewController:sendMsgVC animated:YES];
}


@end
