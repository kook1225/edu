//
//  EDPubulishViewController.m
//  education
//
//  Created by Apple on 15/7/29.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPubulishViewController.h"

@interface EDPubulishViewController ()<UITextViewDelegate>
{
    UIDatePicker *datePicker;
    NSString *dateString;
}
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIView *blurView;

@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation EDPubulishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发布作业";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 162)];
    _blurView.backgroundColor = [UIColor colorWithRed:51/255.0f green:57/255.0f blue:71/255.0f alpha:0.5];
    _blurView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc]init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    dateString = [formatter_minDate stringFromDate:[NSDate date]];
    _dateLabel.text = dateString;
    
    [self drawlayer];
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

- (void)drawlayer
{
    _dateView.layer.cornerRadius = 4.0f;
    _dateView.layer.borderWidth = 1.0;
    _dateView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    
    _publishBtn.layer.cornerRadius = 4.0f;
    
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
   

}

- (IBAction)publishFunction:(id)sender
{
    if ([_textView.text isEqualToString:@""] ||[_textView.text isEqualToString:@"请输入发布作业内容"]) {
        SHOW_ALERT(@"提示", @"发布内容不能为空");
    }else
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"Loading";
        HUD.removeFromSuperViewOnHide = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSDictionary *pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                         @"content":_textView.text,
                         @"bjid":_banji,
                         @"fbsj":dateString
                         };
       
        NSString *urlString = [NSString stringWithFormat:@"%@Homework",SERVER_HOST];
        
        [manager POST:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD setHidden:YES];
            NSLog(@"res--%@",responseObject);
            if ([responseObject[@"responseCode"] intValue] ==0)
            {
                _msgView.hidden = NO;
                _msgLabel.text = responseObject[@"responseMessage"];
                [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                _msgView.hidden = NO;
                _msgLabel.text = responseObject[@"responseMessage"];
                [self performSelector:@selector(hiddenView) withObject:self afterDelay:2.0];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD setHidden:YES];
            if (operation.response.statusCode == 401) {
                NSLog(@"请求超时");
                //   [SEUtils repetitionLogin];
            }else if(error.code == -1001)
            {
                SHOW_ALERT(@"提示", @"网络请求超时");
            }else if (error.code == -1009)
            {
                SHOW_ALERT(@"提示", @"网络连接已断开");
            }
            else {
                NSLog(@"Error:%@",error);
                NSLog(@"err:%@",operation.responseObject[@"message"]);
                //   SHOW_ALERT(@"提示",operation.responseObject[@"message"])
            }
        }];

    }
}

#pragma mark 日历
- (IBAction)cancelFunction:(id)sender {
    _blurView.hidden = YES;
}
- (IBAction)sureFunction:(id)sender {
    _blurView.hidden = YES;
    _dateLabel.text = dateString;
    
}
- (IBAction)dateTap:(id)sender
{
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc]init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *maxDate = [formatter_minDate dateFromString:@"2100-01-01"];
    
    datePicker.minimumDate = [NSDate date];
    datePicker.maximumDate = maxDate;
    [_containView addSubview:datePicker];
    [self pickViewShow];

}

- (void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker *)sender;
    NSDate *_date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [dateFormatter stringFromDate:_date];
    
}

- (void)pickViewShow
{
    _blurView.hidden = NO;
    [self.navigationController.view addSubview:_blurView];
}
#pragma mark TextView 代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _textView.text = @"";
    return YES;
}
@end
