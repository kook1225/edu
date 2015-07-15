//
//  GrowthTrailViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "GrowthTrailViewController.h"
#import "SETabBarViewController.h"
#import "JournalCell.h"
#import "EDGrowDetailViewController.h"
#import "EvaluteAndEncourageViewController.h"
#import "EDPrivateDetailViewController.h"
#import "growUpModel.h"

@interface GrowthTrailViewController () {
    SETabBarViewController *tabBarViewController;
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GrowthTrailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成长足迹";
    
    dataArray = [NSArray array];
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    [self growUpApi];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [rightBarBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [rightBarBtn setTitle:@"发表" forState:UIControlStateNormal];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = btnItem2;
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)growUpApi {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],@"XSID":[[[[SEUtils getUserInfo] UserDetail] studentInfo] ID],@"pageSize":@"10",@"page":@"1"};
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ChengZhang",SERVER_HOST];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 dataArray = [growUpModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                 
                 //[_tableView reloadData];
             }
             else {
                 SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
             }
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [HUD hide:YES];
             if (operation.response.statusCode == 401) {
                 NSLog(@"请求超时");
                 //   [SEUtils repetitionLogin];
             }
             else {
                 NSLog(@"Error:%@",error);
                 NSLog(@"err:%@",operation.responseObject[@"message"]);
                 //   SHOW_ALERT(@"提示",operation.responseObject[@"message"])
             }
         }];
}

- (void)sendBtn {
    EDGrowDetailViewController *growDetailVC = [[EDGrowDetailViewController alloc]init];
    [self.navigationController pushViewController:growDetailVC animated:YES];

}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 2) {
        EDPrivateDetailViewController *privateDetailVC = [[EDPrivateDetailViewController alloc] init];
        [self.navigationController pushViewController:privateDetailVC animated:YES];
    }
    else {
        EvaluteAndEncourageViewController *evaluteAndEncourageVC = [[EvaluteAndEncourageViewController alloc] init];
        [self.navigationController pushViewController:evaluteAndEncourageVC animated:YES];
    }
  
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JournalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"journalCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JournalCell" owner:self options:nil] lastObject];
    }
    
    if (indexPath.row <= 2) {
        [cell setData:1];
    }
    else {
        [cell setData:2];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
