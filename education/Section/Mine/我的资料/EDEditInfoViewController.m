//
//  EDEditInfoViewController.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDEditInfoViewController.h"
#import "SETabBarViewController.h"

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
    [tabBarView tabBarViewHidden    ];
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
}

@end
