//
//  EDEditTeacherInfoViewController.m
//  education
//
//  Created by Apple on 15/7/28.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDEditTeacherInfoViewController.h"
#import "SETabBarViewController.h"
#import <UIImageView+WebCache.h>

@interface EDEditTeacherInfoViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;

@end

@implementation EDEditTeacherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的资料";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    [self drawlayer];

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
    
    
    
   
    _location.text = [SEUtils getUserInfo].UserDetail.schoolInfo.DWMC;
    _schoolLabel.text = [SEUtils getUserInfo].UserDetail.studentInfo.DWMC;

    _nameLabel.text = [SEUtils getUserInfo].UserDetail.teacherInfo.JSXM;
    _subLabel.text = [SEUtils getUserInfo].UserDetail.teacherInfo.RJXK;
    _professionLabel.text = [SEUtils getUserInfo].UserDetail.teacherInfo.SRZW;
   
    
    NSURL *url = [NSURL URLWithString:[SEUtils getUserInfo].UserDetail.userinfo.YHTX];
    [_headImg sd_setImageWithURL:url placeholderImage:nil];
}


@end
