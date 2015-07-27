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
#import "ManageAddViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()<UIAlertViewDelegate> {
    SETabBarViewController *tabBarViewController;
}
@property (weak, nonatomic) IBOutlet UIView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _exitBtn.layer.cornerRadius = 5.0f;
    _exitBtn.layer.masksToBounds = YES;
    
    
    if ([[[[[SEUtils getUserInfo] UserDetail] userinfo] YHLB] intValue] != 3) {
        _nameLabel.text = [[[SEUtils getUserInfo] UserDetail] studentInfo].XSXM;
        _addLabel.text = [NSString stringWithFormat:@"%@%@",[[[[SEUtils getUserInfo] UserDetail] studentInfo] NJMC],[[[[SEUtils getUserInfo] UserDetail] studentInfo] BJMC]];
    }
    else {
        _nameLabel.text = [[[SEUtils getUserInfo] UserDetail] teacherInfo].JSXM;
    }
    
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
    ManageAddViewController *manageAddVC = [[ManageAddViewController alloc] init];
    [self.navigationController pushViewController:manageAddVC animated:YES];
}

- (IBAction)userPhotoTap:(id)sender {
    EDMyPhotoViewController *photoVC = [[EDMyPhotoViewController alloc]init];
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (IBAction)changePwdTap:(id)sender {
    EDAlterPwdViewController *alterPwdVC = [[EDAlterPwdViewController alloc]init];
    [self.navigationController pushViewController:alterPwdVC animated:YES];
}

- (IBAction)exitBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退出账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 201;
    [alert show];
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
