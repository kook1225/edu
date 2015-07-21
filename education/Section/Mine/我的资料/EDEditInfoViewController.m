//
//  EDEditInfoViewController.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDEditInfoViewController.h"
#import "SETabBarViewController.h"
#import "UIImageView+WebCache.h"


@interface EDEditInfoViewController ()
{
    SETabBarViewController *tabBarView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation EDEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的资料";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 900);
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
    
    
    
    _userId.text = [SEUtils getUserInfo].UserDetail.userinfo.ID;
    _location.text = [SEUtils getUserInfo].UserDetail.studentInfo.QYMC;
    _school.text = [SEUtils getUserInfo].UserDetail.studentInfo.DWMC;
    _grade.text = [SEUtils getUserInfo].UserDetail.studentInfo.NJMC;
    _college.text = [SEUtils getUserInfo].UserDetail.studentInfo.BJMC;
    _userName.text = [SEUtils getUserInfo].UserDetail.studentInfo.XSXM;
    _sex.text = [SEUtils getUserInfo].UserDetail.studentInfo.XSXB;
//    _birthDay.text = [SEUtils getUserInfo].UserDetail.studentInfo.DWMC;
    _momName.text = [SEUtils getUserInfo].UserDetail.studentInfo.MQXM;
    _momPhone.text = [SEUtils getUserInfo].UserDetail.studentInfo.MQDH;
    _dadName.text = [SEUtils getUserInfo].UserDetail.studentInfo.FQXM;
    _dadPhone.text = [SEUtils getUserInfo].UserDetail.studentInfo.FQDH;
    
    NSURL *url = [NSURL URLWithString:[SEUtils getUserInfo].UserDetail.userinfo.YHTX];
    [_headImg sd_setImageWithURL:url placeholderImage:nil];
}

@end
