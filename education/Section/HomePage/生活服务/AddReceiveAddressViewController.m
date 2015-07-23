//
//  AddReceiveAddressViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "AddReceiveAddressViewController.h"
#import "AreaModel.h"

@interface AddReceiveAddressViewController () {
    int addFlag;
    NSArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *addIntroTextField;
@property (weak, nonatomic) IBOutlet UITextField *ZipCodeTextField;

@end

@implementation AddReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增收货地址";
    
    addFlag = 0;
    
    _saveBtn.layer.cornerRadius = 5.0f;
    
    //[self areaSelect];
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)areaSelect {

}

- (IBAction)saveBtn:(id)sender {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@AddShipAddress",SERVER_HOST];
    
    NSString *code = [SEUtils encryptUseDES:[[[SEUtils getUserInfo] TokenInfo] access_token] key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
    
    NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                @"code":code,
                                @"member_id":[[[[SEUtils getUserInfo] UserDetail] userinfo] ID],
                                @"contact":_nameTextField.text,
                                @"tel":_mobileTextField.text,
                                @"province":@"湖南省",
                                @"city":@"长沙市",
                                @"district":@"开福区",
                                @"address":_addIntroTextField.text,
                                @"zipcode":_ZipCodeTextField.text,
                                @"is_default":[NSNumber numberWithInt:addFlag]};
    
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 
                 //[self showPicker:btn.tag];
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

- (IBAction)setAdd:(id)sender {
    if (addFlag == 1) {
        [_checkImageView setImage:[UIImage imageNamed:@"uncheckBtn"]];
        addFlag = 0;
    }
    else {
        [_checkImageView setImage:[UIImage imageNamed:@"checkBtn"]];
        addFlag = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
