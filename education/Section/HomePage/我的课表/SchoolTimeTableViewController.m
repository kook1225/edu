//
//  SchoolTimeTableViewController.m
//  education
//
//  Created by zhujun on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SchoolTimeTableViewController.h"
#import "SETabBarViewController.h"
#import "SchoolTimeTableModel.h"

@interface SchoolTimeTableViewController () {
    SETabBarViewController *tabBarView;
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UIView *courseView1;
@property (weak, nonatomic) IBOutlet UIView *courseView2;
@property (weak, nonatomic) IBOutlet UIView *courseView3;
@property (weak, nonatomic) IBOutlet UIView *courseView4;
@property (weak, nonatomic) IBOutlet UIView *courseView5;
@property (weak, nonatomic) IBOutlet UIView *courseView6;
@property (weak, nonatomic) IBOutlet UIView *courseView7;

@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;

@end

@implementation SchoolTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的课表";
    
    dataArray = [NSArray array];
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    _dateView.layer.cornerRadius = 5.0f;
    
    [self timeTable];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    
}

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenView
{
    _msgView.hidden = YES;
}


- (void)timeTable {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3)
    {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"BJID":_detailId
                      };
    }else
    {
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"BJID":@""
//                      [[[SEUtils getUserInfo] UserDetail] studentInfo] BJID]
                      };
    }
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ClassSchedule",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [HUD hide:YES];
              
              NSError *err;
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  dataArray = [SchoolTimeTableModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                  
                  for (int i = 1; i <= 7; i++) {
                      for (int j = 0; j < [dataArray count]; j++) {
                          if (j == 0) {
                              UILabel *courseLabel = (UILabel *)[_courseView1 viewWithTag:i];
                              if (i == 1) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                          else if (j == 1) {
                              UILabel *courseLabel = (UILabel *)[_courseView2 viewWithTag:i];
                              if (i == 1) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                          else if (j == 2) {
                              UILabel *courseLabel = (UILabel *)[_courseView3 viewWithTag:i];
                              if (i == 1) {
                                  //courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                          else if (j == 3) {
                              UILabel *courseLabel = (UILabel *)[_courseView4 viewWithTag:i];
                              if (i == 1) {
                                  //courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                          else if (j == 4) {
                              UILabel *courseLabel = (UILabel *)[_courseView5 viewWithTag:i];
                              if (i == 1) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                          else if (j == 5) {
                              UILabel *courseLabel = (UILabel *)[_courseView6 viewWithTag:i];
                              if (i == 1) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                          else if (j == 6) {
                              UILabel *courseLabel = (UILabel *)[_courseView7 viewWithTag:i];
                              if (i == 1) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC01];
                              }
                              else if (i == 2) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC02];
                              }
                              else if (i == 3) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC03];
                              }
                              else if (i == 4) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC04];
                              }
                              else if (i == 5) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC05];
                              }
                              else if (i == 6) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC06];
                              }
                              else if (i == 7) {
                                  courseLabel.text = [[dataArray objectAtIndex:j] KC07];
                              }
                          }
                      }
                  }
                  
              }
              else {
                  _msgView.hidden = NO;
                  _msgLabel.text = responseObject[@"responseMessage"];
                  [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [HUD hide:YES];
              if(error.code == -1001)
              {
                  SHOW_ALERT(@"提示", @"网络请求超时");
              }else if (error.code == -1009)
              {
                  SHOW_ALERT(@"提示", @"网络连接已断开");
              }
          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
