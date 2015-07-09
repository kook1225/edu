//
//  ParentRegisterViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ParentRegisterViewController.h"
#import "FillInforViewController.h"

@interface ParentRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ParentRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家长注册";
    
    _nextBtn.layer.cornerRadius = 5.0f;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)nextBtn:(id)sender {
    FillInforViewController *fillIntroVC = [[FillInforViewController alloc] init];
    [self.navigationController pushViewController:fillIntroVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
