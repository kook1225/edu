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
    
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBarBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
}

#pragma mark - Custom Method
- (void)backBtn {
    NSLog(@"隐藏按钮");
}

- (IBAction)seeOrderBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayEndViewController"
                                                        object:@"popOrderList"
                                                      userInfo:@{}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
