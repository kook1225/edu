//
//  AddReceiveAddressViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "AddReceiveAddressViewController.h"

@interface AddReceiveAddressViewController () {
    BOOL addFlag;
}
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation AddReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增收货地址";
    
    addFlag = NO;
    
    _saveBtn.layer.cornerRadius = 5.0f;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtn:(id)sender {
    
}

- (IBAction)setAdd:(id)sender {
    if (addFlag) {
        [_checkImageView setImage:[UIImage imageNamed:@"uncheckBtn"]];
        addFlag = NO;
    }
    else {
        [_checkImageView setImage:[UIImage imageNamed:@"checkBtn"]];
        addFlag = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
