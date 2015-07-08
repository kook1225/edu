//
//  FillInforViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "FillInforViewController.h"

@interface FillInforViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation FillInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写资料";
    
    _registerBtn.layer.cornerRadius = 5.0f;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registerBtn:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
