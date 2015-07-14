//
//  FillInforViewController.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "FillInforViewController.h"

@interface FillInforViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate> {
    NSString *seletedMajorNames;
    NSArray *dataArray;
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
    
    dataArray = @[@"傻瓜",@"笨蛋",@"八嘎"];
    
    _registerBtn.layer.cornerRadius = 5.0f;
    
    
    for (int i = 0; i < 4; i++) {
        UIView *sessionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.view.bounds), SCREENWIDTH, 216)];
        sessionView.tag = 301 + i;
        sessionView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8];
        [self.view addSubview:sessionView];
        
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 216)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
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
        if (btn.tag == 501) {
            _areaLabel.text = [dataArray objectAtIndex:0];
        }
        else if (btn.tag == 502) {
            _schoolLabel.text = [dataArray objectAtIndex:0];
        }
        else if (btn.tag == 502) {
            _gradeLabel.text = [dataArray objectAtIndex:0];
        }
        else {
            _classLabel.text = [dataArray objectAtIndex:0];
        }
    }
    else {
        if (btn.tag == 501) {
            _areaLabel.text = seletedMajorNames;
        }
        else if (btn.tag == 502) {
            _schoolLabel.text = seletedMajorNames;
        }
        else if (btn.tag == 502) {
            _gradeLabel.text = seletedMajorNames;
        }
        else {
            _classLabel.text = seletedMajorNames;
        }
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
    UIButton *btn = (UIButton *)sender;
    [self showPicker:btn.tag];
}

- (IBAction)schoolBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self showPicker:btn.tag];
}

- (IBAction)gradeBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self showPicker:btn.tag];
}

- (IBAction)classBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self showPicker:btn.tag];
}


- (IBAction)registerBtn:(id)sender {
    _registerBtn.enabled = NO;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@Register",SERVER_HOST];
    
    NSDictionary *parameter = @{@"username":_userName,@"pwd":_pwd,@"qyid":@"430111",@"dwid":@"430111030058",@"njid":@"43011103005812014",@"bjid":@"4301110300581201401",@"xsxm":_nameTextField.text};
    
    [manager POST:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              _registerBtn.enabled = YES;
              [HUD hide:YES];
              

              if ([responseObject[@"data"]  isEqual: @"true"]) {
                  

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

#pragma mark - UIPickerViewDataSource Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [dataArray count];
}

#pragma mark - UIPickerViewDelegate Method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [dataArray objectAtIndex:row];
    
    /*
     if (component == majorComponent) {
     return [majorNames objectAtIndex:row];
     } else {
     return [grades objectAtIndex:row];
     }
     */
   
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    seletedMajorNames = [dataArray objectAtIndex:row];
    
    /*
     if (component == majorComponent) {
     seletedMajorNames = [majorNames objectAtIndex:row];
     NSLog(@"MajorNames:%@",seletedMajorNames);
     }
     else {
     seletedGrades = [grades objectAtIndex:row];
     NSLog(@"Grades:%@",seletedGrades);
     }
     */
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    for (int i = 301; i <= 304; i ++) {
        [self hiddenPicker:i];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
