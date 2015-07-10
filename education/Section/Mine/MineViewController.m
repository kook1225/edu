//
//  MineViewController.m
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "MineViewController.h"
#import "SETabBarViewController.h"
#import "EDEditInfoViewController.h"
#import "EDMyOrderViewController.h"
#import "EDAlterPwdViewController.h"
#import "EDMyPhotoViewController.h"
#import "SelectAddViewController.h"

@interface MineViewController () {
    SETabBarViewController *tabBarViewController;
}
@property (weak, nonatomic) IBOutlet UIView *topImageView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    
    _topImageView.layer.cornerRadius = _topImageView.frame.size.width / 2.0;
    _topImageView.layer.borderWidth = 2;
    _topImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _topImageView.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    }

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    
    [tabBarViewController tabBarViewShow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    
}
#pragma mark - Custom Method
- (IBAction)userIntroTap:(id)sender {
    EDEditInfoViewController *editInfoVC = [[EDEditInfoViewController alloc]init];
    [self.navigationController pushViewController:editInfoVC animated:YES];
}

- (IBAction)userOrderTap:(id)sender {
    EDMyOrderViewController *orderVC = [[EDMyOrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)userAddTap:(id)sender {
    SelectAddViewController *selectAddVC = [[SelectAddViewController alloc] init];
    [self.navigationController pushViewController:selectAddVC animated:YES];
}

- (IBAction)userPhotoTap:(id)sender {
    EDMyPhotoViewController *photoVC = [[EDMyPhotoViewController alloc]init];
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (IBAction)changePwdTap:(id)sender {
    EDAlterPwdViewController *alterPwdVC = [[EDAlterPwdViewController alloc]init];
    [self.navigationController pushViewController:alterPwdVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
