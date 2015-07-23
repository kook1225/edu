//
//  SelectAddViewController.m
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SelectAddViewController.h"
#import "SelectAddCell.h"
#import "ManageAddViewController.h"
#import "SETabBarViewController.h"
#import "ShipAddListModel.h"

@interface SelectAddViewController () {
    SETabBarViewController *tabBarView;
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *manageAddBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择收货地址";
    
    _manageAddBtn.layer.cornerRadius = 5.0f;
    
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addList];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addList {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    NSString *code = [SEUtils encryptUseDES:[[[SEUtils getUserInfo] TokenInfo] access_token] key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
    NSLog(@"code:%@",code);
    
    //NSString *text = [SEUtils decryptUseDES:code key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
    //NSLog(@"text:%@",text);
    
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"code":code
                  };
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ShipAddress",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 if (responseObject[@"data"] == [NSNull null]) {
                     
                 }
                 else {
                     dataArray = [ShipAddListModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                     [_tableView reloadData];
                 }
             }
             else {
                 SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
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

- (IBAction)manageAddBtn:(id)sender {
    ManageAddViewController *manageAddVC = [[ManageAddViewController alloc] init];
    [self.navigationController pushViewController:manageAddVC animated:YES];
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate selectedAdd:[[dataArray objectAtIndex:indexPath.row] id]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectAddCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddCell" owner:self options:nil] lastObject];
    }
  
    if ([_checkID isEqualToString:[[dataArray objectAtIndex:indexPath.row] id]]) {
        [cell setData];
    }
    
    if ([_checkID  isEqual: @""]) {
        if (indexPath.row == 0) {
            [cell setData];
        }
    }
    
    [cell setData:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
