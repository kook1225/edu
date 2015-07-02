//
//  MineViewController.m
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "MineViewController.h"
#import "SETabBarViewController.h"

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

#pragma mark - Custom Method
- (IBAction)userIntroTap:(id)sender {
    NSLog(@"1");
}

- (IBAction)userOrderTap:(id)sender {
    NSLog(@"2");
}

- (IBAction)userAddTap:(id)sender {
    NSLog(@"3");
}

- (IBAction)userPhotoTap:(id)sender {
    NSLog(@"4");
}

- (IBAction)changePwdTap:(id)sender {
    NSLog(@"5");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
