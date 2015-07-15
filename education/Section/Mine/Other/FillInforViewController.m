//
//  FillInforViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "FillInforViewController.h"
#import "AreaModel.h"
#import "SchoolModel.h"
#import "GradeModel.h"
#import "ClassModel.h"

@interface FillInforViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIAlertViewDelegate> {
    NSString *seletedMajorNames;
    NSArray *dataArray;
    NSString *areaId;
    NSString *schoolId;
    NSString *gradeId;
    NSString *classId;
    
    int flag;
}
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@end

@implementation FillInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写资料";
    
    dataArray = [NSArray array];
    
    _registerBtn.layer.cornerRadius = 5.0f;
    _registerBtn.layer.masksToBounds = YES;
    
    for (int i = 0; i < 4; i++) {
        UIView *sessionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds), SCREENWIDTH, 216)];
        sessionView.tag = 301 + i;
        sessionView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8];
        [self.view addSubview:sessionView];
        
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 216)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.tag = 701 + i;
        [sessionView addSubview:pickerView];
        
        
        UIButton *_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(SCREENWIDTH - 70, 10, 60, 30);
        _submitButton.layer.cornerRadius = 5.0f;
        _submitButton.tag = 501 + i;
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        _submitButton.backgroundColor = BUTTONCOLOR;
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [sessionView addSubview:_submitButton];
        
        UIButton *_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10, 10, 60, 30);
        _cancelButton.layer.cornerRadius = 5.0f;
        _cancelButton.tag = 601 + i;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = BUTTONCOLOR;
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [sessionView addSubview:_cancelButton];
    }

    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (!seletedMajorNames) {
        if ([dataArray count] != 0) {
            if (btn.tag == 501) {
                areaId = [[dataArray objectAtIndex:0] QYID];
                _areaLabel.text = [[dataArray objectAtIndex:0] QYMC];
            }
            else if (btn.tag == 502) {
                schoolId = [[dataArray objectAtIndex:0] DWID];
                _schoolLabel.text = [[dataArray objectAtIndex:0] DWMC];
            }
            else if (btn.tag == 503) {
                gradeId = [[dataArray objectAtIndex:0] NJID];
                _gradeLabel.text = [[dataArray objectAtIndex:0] NJMC];
            }
            else {
                classId = [[dataArray objectAtIndex:0] BJID];
                _classLabel.text = [[dataArray objectAtIndex:0] BJMC];
            }
        }
        seletedMajorNames = nil;
    }
    else {
        if (btn.tag == 501) {
            _areaLabel.text = seletedMajorNames;
        }
        else if (btn.tag == 502) {
            _schoolLabel.text = seletedMajorNames;
        }
        else if (btn.tag == 503) {
            _gradeLabel.text = seletedMajorNames;
        }
        else {
            _classLabel.text = seletedMajorNames;
        }
        seletedMajorNames = nil;
    }
    [self hiddenPicker:btn.tag - 200];
}

- (void)cancelAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self hiddenPicker:btn.tag - 300];
}

- (void)hiddenPicker:(NSInteger)tag {
    UIView *pickView = [self.view viewWithTag:tag];
    [UIView animateWithDuration:.25f animations:^{
        pickView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds), SCREENWIDTH, 216);
    }];
}

- (void)showPicker:(NSInteger)tag {
    UIView *pickView = [self.view viewWithTag:tag - 100];
    
    UIPickerView *picker = (UIPickerView *)[pickView viewWithTag:tag + 300];
    [picker reloadAllComponents];
    
    [UIView animateWithDuration:.25f animations:^{
        pickView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds) - 280, SCREENWIDTH, 216);
    }];
    
    for (int i = 301; i <= 304; i ++) {
        if (tag - 100 != i) {
            [self hiddenPicker:i];
        }
    }
    
    [_nameTextField resignFirstResponder];
}

- (IBAction)areaBtn:(id)sender {
    // 设置标识
    flag = 1;
    
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@BaseInfo",SERVER_HOST];
    
    [manager GET:urlStr parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              btn.enabled = YES;
              [HUD hide:YES];
              
              NSError *err;
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  dataArray = [AreaModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                  [self showPicker:btn.tag];
              }
              else {
                  SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
              }
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              btn.enabled = YES;
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

- (IBAction)schoolBtn:(id)sender {
    // 设置标识
    flag = 2;
    
    if ([_areaLabel.text  isEqual: @""]) {
        SHOW_ALERT(@"提示", @"地区不能为空");
    }
    else {
        UIButton *btn = (UIButton *)sender;
        btn.enabled = NO;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"qyid":areaId};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@BaseInfo",SERVER_HOST];
        
        [manager GET:urlStr parameters:parameter
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 btn.enabled = YES;
                 [HUD hide:YES];
                 
                 NSError *err;
                 
                 if ([responseObject[@"responseCode"] intValue] == 0) {
                     dataArray = [SchoolModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                     [self showPicker:btn.tag];
                 }
                 else {
                     SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                 }
                 
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 btn.enabled = YES;
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
}

- (IBAction)gradeBtn:(id)sender {
    // 设置标识
    flag = 3;
    
    if ([_schoolLabel.text  isEqual: @""]) {
        SHOW_ALERT(@"提示", @"学校不能为空");
    }
    else {
        UIButton *btn = (UIButton *)sender;
        btn.enabled = NO;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"dwid":schoolId};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@BaseInfo",SERVER_HOST];
        
        [manager GET:urlStr parameters:parameter
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 btn.enabled = YES;
                 [HUD hide:YES];
                 
                 NSError *err;
                 
                 if ([responseObject[@"responseCode"] intValue] == 0) {
                     dataArray = [GradeModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                     [self showPicker:btn.tag];
                 }
                 else {
                     SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                 }
                 
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 btn.enabled = YES;
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

}

- (IBAction)classBtn:(id)sender {
    // 设置标识
    flag = 4;
    
    if ([_gradeLabel.text  isEqual: @""]) {
        SHOW_ALERT(@"提示", @"年级不能为空");
    }
    else {
        UIButton *btn = (UIButton *)sender;
        btn.enabled = NO;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"njid":gradeId};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@BaseInfo",SERVER_HOST];
        
        [manager GET:urlStr parameters:parameter
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 btn.enabled = YES;
                 [HUD hide:YES];
                 
                 NSError *err;
                 
                 if ([responseObject[@"responseCode"] intValue] == 0) {
                     dataArray = [ClassModel arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
                     [self showPicker:btn.tag];
                 }
                 else {
                     SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                 }
                 
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 btn.enabled = YES;
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

}


- (IBAction)registerBtn:(id)sender {
    if ([_areaLabel.text length] != 0 && [_schoolLabel.text length] != 0 &&[_gradeLabel.text length] != 0 &&[_classLabel.text length] != 0 && [_nameTextField.text length] != 0) {
        _registerBtn.enabled = NO;
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@Register",SERVER_HOST];
        
        NSDictionary *parameter = @{@"username":_userName,@"pwd":_pwd,@"qyid":areaId,@"dwid":schoolId,@"njid":gradeId,@"bjid":classId,@"xsxm":_nameTextField.text};
        
        [manager POST:urlStr parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  _registerBtn.enabled = YES;
                  [HUD hide:YES];
                  
                  if ([responseObject[@"responseCode"] intValue] == 0) {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功，等待审核." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                      alertView.tag = 201;
                      [alertView show];
                  }
                  else {
                      SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
                  }
                  
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  _registerBtn.enabled = YES;
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
    else {
        SHOW_ALERT(@"提示", @"资料不完整，请补充完整");
    }
}

#pragma mark - UIPickerViewDataSource Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [dataArray count];
}

#pragma mark - UIPickerViewDelegate Method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([dataArray count] != 0) {
        if (flag == 1) {
            return [[dataArray objectAtIndex:row] QYMC];
        }
        else if (flag == 2) {
            return [[dataArray objectAtIndex:row] DWMC];
        }
        else if (flag == 3) {
            return [[dataArray objectAtIndex:row] NJMC];
        }
        else if (flag == 4) {
            return [[dataArray objectAtIndex:row] BJMC];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([dataArray count] != 0) {
        if (flag == 1) {
            areaId = [[dataArray objectAtIndex:row] QYID];
            seletedMajorNames = [[dataArray objectAtIndex:row] QYMC];
        }
        else if (flag == 2) {
            schoolId = [[dataArray objectAtIndex:row] DWID];
            seletedMajorNames = [[dataArray objectAtIndex:row] DWMC];
        }
        else if (flag == 3) {
            gradeId = [[dataArray objectAtIndex:row] NJID];
            seletedMajorNames = [[dataArray objectAtIndex:row] NJMC];
        }
        else if (flag == 4) {
            classId = [[dataArray objectAtIndex:row] BJID];
            seletedMajorNames = [[dataArray objectAtIndex:row] BJMC];
        }
    }
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    for (int i = 301; i <= 304; i ++) {
        [self hiddenPicker:i];
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate Method 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 0) {
            [_delegate Login];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
