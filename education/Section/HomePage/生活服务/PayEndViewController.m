//
//  PayEndViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "PayEndViewController.h"

@interface PayEndViewController ()
@property (weak, nonatomic) IBOutlet UIButton *seeOrderBtn;

@end

@implementation PayEndViewController

- (void)viewDidLoad {
    self.title = @"支付结果";
    
    _seeOrderBtn.layer.cornerRadius = 5.0f;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seeOrderBtn:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
