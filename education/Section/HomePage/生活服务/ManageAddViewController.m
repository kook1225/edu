//
//  ManageAddViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ManageAddViewController.h"
#import "SelectAddCell.h"
#import "AddReceiveAddressViewController.h"
#import "EditAddViewController.h"
#import "SETabBarViewController.h"

@interface ManageAddViewController () {
    SETabBarViewController *tabBarViewController;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;

@end

@implementation ManageAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理收货地址";
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    _addAddressBtn.layer.cornerRadius = 5.0f;
    
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
    HUD.labelText = @"加载中...";
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
                     _dataArray = [ShipAddListModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
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

- (IBAction)addBtn:(id)sender {
    AddReceiveAddressViewController *addReceiveAddressVC = [[AddReceiveAddressViewController alloc] init];
    [self.navigationController pushViewController:addReceiveAddressVC animated:YES];
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditAddViewController *editAddVC = [[EditAddViewController alloc] init];
    editAddVC.shipAddModel = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:editAddVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectAddCell"];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddCell" owner:self options:nil] lastObject];
    }
    

    [cell setData:[_dataArray objectAtIndex:indexPath.row]];

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
