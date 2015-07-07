//
//  EDSetProblemViewController.m
//  education
//
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDSetProblemViewController.h"
#import "SETabBarViewController.h"

@interface EDSetProblemViewController ()
{
    SETabBarViewController *tabBarView;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation EDSetProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"问题反馈";
    
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
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = LINECOLOR.CGColor;
    _textView.layer.borderWidth = 1.0f;
    
    _commitBtn.layer.cornerRadius = 4.0f;
    _commitBtn.layer.masksToBounds = YES;
    
}
- (IBAction)commitFunction:(id)sender {
}

@end
