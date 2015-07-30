//
//  EditAddViewController.m
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EditAddViewController.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "DistrictModel.h"

@interface EditAddViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate> {
    int addFlag;
    
    UIView *sessionView;
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *districtArray;
    UIPickerView *picView;
    
    NSString *provinceID;
    NSString *cityID;
    NSString *districtID;
    
    NSString *provinceName;
    NSString *cityName;
    NSString *districtName;
}
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *addIntroTextField;
@property (weak, nonatomic) IBOutlet UITextField *ZipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;

@end

@implementation EditAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑地址";
    
    _saveBtn.layer.cornerRadius = 5.0f;
    
    provinceArray = [NSArray array];
    cityArray = [NSArray array];
    districtArray = [NSArray array];
    
    provinceName = _shipAddModel.province;
    cityName = _shipAddModel.city;
    districtName = _shipAddModel.district;
    
    _nameTextField.text = _shipAddModel.contact;
    _mobileTextField.text = _shipAddModel.tel;
    _areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",_shipAddModel.province,_shipAddModel.city,_shipAddModel.district];
    _addIntroTextField.text = _shipAddModel.address;
    _ZipCodeTextField.text = _shipAddModel.zip_code;
    addFlag = [_shipAddModel.is_default intValue];
    

    if (addFlag == 1) {
        [_checkImageView setImage:[UIImage imageNamed:@"checkBtn"]];
    }
    else {
        [_checkImageView setImage:[UIImage imageNamed:@"uncheckBtn"]];
    }
    
    
    sessionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds), SCREENWIDTH, 216)];
    sessionView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8];
    [self.view addSubview:sessionView];
    
    
    picView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 216)];
    picView.delegate = self;
    picView.dataSource = self;
    [sessionView addSubview:picView];
    
    
    UIButton *_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(SCREENWIDTH - 70, 10, 60, 30);
    _submitButton.layer.cornerRadius = 5.0f;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
    _submitButton.backgroundColor = BUTTONCOLOR;
    [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [sessionView addSubview:_submitButton];
    
    UIButton *_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(10, 10, 60, 30);
    _cancelButton.layer.cornerRadius = 5.0f;
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.backgroundColor = BUTTONCOLOR;
    [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [sessionView addSubview:_cancelButton];
    
    
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction {
    _areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,districtName];
    
    [self hiddenPicker];
}

- (void)cancelAction {
    [self hiddenPicker];
}

- (void)hiddenPicker {
    [UIView animateWithDuration:.25f animations:^{
        sessionView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds), SCREENWIDTH, 216);
    }];
}

- (void)showPicker {
    [picView selectRow:0 inComponent:0 animated:NO];
    [picView selectRow:0 inComponent:2 animated:NO];
    [self selectProvince:0 cityTag:0];
    
    [UIView animateWithDuration:.25f animations:^{
        sessionView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds) - 280 - 50, SCREENWIDTH, 216);
    }];
    
    [_nameTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    [_addIntroTextField resignFirstResponder];
    [_ZipCodeTextField resignFirstResponder];
}

- (IBAction)areaSelect:(id)sender {
    [self showPicker];
}


- (void)selectProvince:(int)index cityTag:(int)row{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@AreaInfo",SERVER_HOST];
    
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 provinceArray = [ProvinceModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                 
                 provinceID = [[provinceArray objectAtIndex:index] ProvinceID];
                 provinceName = [[provinceArray objectAtIndex:index] ProvinceName];
                 
                 [self selectCity:provinceID index:row];
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

- (void)selectCity:(NSString *)proinceId index:(int)row {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@AreaInfo",SERVER_HOST];
    
    NSDictionary *parameter = @{@"provinceid":proinceId};
    
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 cityArray = [CityModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                 
                 cityID = [[cityArray objectAtIndex:row] CityID];
                 cityName = [[cityArray objectAtIndex:row] CityName];
                 
                 [self selectDistrict:cityID index:0];
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

- (void)selectDistrict:(NSString *)cityId index:(int)row{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@AreaInfo",SERVER_HOST];
    
    NSDictionary *parameter = @{@"cityid":cityId};
    
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 districtArray = [DistrictModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                 
                 districtName = [[districtArray objectAtIndex:row] DistrictName];
                 
                 [picView reloadAllComponents];
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

- (IBAction)saveBtn:(id)sender {
    if ([_nameTextField.text length] == 0) {
        SHOW_ALERT(@"提示", @"收货人不能为空");
    }
    else {
        if ([_mobileTextField.text length] == 0) {
            SHOW_ALERT(@"提示", @"手机号码不能为空");
        }
        else {
            if (![SEUtils isValidateMobile:_mobileTextField.text]) {
                SHOW_ALERT(@"提示", @"手机号码格式不正确");
            }
            else {
                if ([_areaTextField.text length] == 0) {
                    SHOW_ALERT(@"提示", @"省市区不能为空");
                }
                else {
                    if ([_addIntroTextField.text length] == 0) {
                        SHOW_ALERT(@"提示", @"详细地址不能为空");
                    }
                    else {
                        if ([_ZipCodeTextField.text length] == 0) {
                            SHOW_ALERT(@"提示", @"邮政编码不能为空");
                        }
                        else {
                            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            HUD.mode = MBProgressHUDModeIndeterminate;
                            HUD.labelText = @"加载中...";
                            HUD.removeFromSuperViewOnHide = YES;
                            
                            
                            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                            
                            NSString *urlStr = [NSString stringWithFormat:@"%@ShipAddress",SERVER_HOST];
                            
                            NSString *code = [SEUtils encryptUseDES:[[[SEUtils getUserInfo] TokenInfo] access_token] key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
                            
                            NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                                        @"code":code,
                                                        @"id":_shipAddModel.id,
                                                        @"member_id":[[[[SEUtils getUserInfo] UserDetail] userinfo] ID],
                                                        @"contact":_nameTextField.text,
                                                        @"tel":_mobileTextField.text,
                                                        @"province":provinceName,
                                                        @"city":cityName,
                                                        @"district":districtName,
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
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"编辑成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                          alert.tag = 201;
                                          [alert show];
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
                    }
                }
            }
        }
    }

}

- (IBAction)deleteBtn:(id)sender {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@DelShipAddress",SERVER_HOST];
    
    NSString *code = [SEUtils encryptUseDES:[[[SEUtils getUserInfo] TokenInfo] access_token] key:[[[[SEUtils getUserInfo] UserDetail] userinfo] YHM]];
    
    NSDictionary *parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                                @"code":code,
                                @"id":_shipAddModel.id,
                                @"member_id":[[[[SEUtils getUserInfo] UserDetail] userinfo] ID]
                                };
    
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager DELETE:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [HUD hide:YES];
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                  alert.tag = 201;
                  [alert show];
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

#pragma mark - UIPickerViewDataSource Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [provinceArray count];
    }
    else if (component == 1) {
        return [cityArray count];
    }
    else {
        return [districtArray count];
    }
}

#pragma mark - UIPickerViewDelegate Method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[provinceArray objectAtIndex:row] ProvinceName];
    }
    else if (component == 1) {
        return [[cityArray objectAtIndex:row] CityName];
    }
    else {
        return [[districtArray objectAtIndex:row] DistrictName];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self selectProvince:(int)row cityTag:0];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if (component == 1){
        [self selectCity:provinceID index:(int)row];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else {
        [self selectDistrict:cityID index:(int)row];
    }
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hiddenPicker];
    return YES;
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
