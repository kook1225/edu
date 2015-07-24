//
//  EDHomeWorkViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDHomeWorkViewController.h"
#import "SETabBarViewController.h"

@interface EDHomeWorkViewController ()
{
    SETabBarViewController *tabBarView;
    CGFloat TAB_WITHDE;
    NSMutableArray *dataArray;
    UIDatePicker *datePicker;
    NSString *dateString;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation EDHomeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"家庭作业";
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"homeWork"];
    
    CGFloat slide_x= 0;
    CGFloat slide_y = 0;
     TAB_WITHDE = 0;
    CGFloat TAB_HEIGHT = 0;
    if (SCREENHEIGHT == 480)
    {
        slide_x = 68;
        slide_y = 160;
        TAB_WITHDE = 184;
        TAB_HEIGHT = 144;
    }else if (SCREENHEIGHT == 568)
    {
        slide_x = 68;
        slide_y = 200;
        TAB_WITHDE = 184;
        TAB_HEIGHT = 170;
    }else if (SCREENHEIGHT == 667)
    {
        slide_x = 80;
        slide_y = 240;
        TAB_WITHDE = 213;
        TAB_HEIGHT = 186;
    }else
    {
        slide_x = 90;
        slide_y = 270;
        TAB_WITHDE = 230;
        TAB_HEIGHT = 210;
    }
    
    
    _tableView.frame = CGRectMake(slide_x, slide_y, TAB_WITHDE, TAB_HEIGHT);
    _dateView.layer.cornerRadius = 6.0f;
    _dateView.layer.borderWidth = 0.5f;
    _dateView.layer.borderColor = [UIColor colorWithRed:109/255.0f green:114/255.0f blue:122/255.0f alpha:1.0].CGColor;

    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 162)];
    _blurView.backgroundColor = [UIColor colorWithRed:51/255.0f green:57/255.0f blue:71/255.0f alpha:0.5];
    _blurView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    [self AFNRequest:@""];
}


#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelFunction:(id)sender {
    _blurView.hidden = YES;
}
- (IBAction)sureFunction:(id)sender {
    _blurView.hidden = YES;
    _dateLabel.text = dateString;
    [self AFNRequest:dateString];
}

- (IBAction)dateTap:(id)sender {
    NSLog(@"1");
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc]init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd EEE"];
    
    NSDate *minDate = [formatter_minDate dateFromString:@"2014-01-01"];
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = [NSDate date];
    [_containView addSubview:datePicker];
     dateString = [formatter_minDate stringFromDate:[NSDate date]];
    [self pickViewShow];
    
}

- (void)AFNRequest:(NSString *)date
{
    dataArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
   NSLog(@"类型--%@",[SEUtils getUserInfo].UserDetail.userinfo.YHLB);
    NSDictionary *pramaters;
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3) {
        //老师
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                    @"type":@"2",
                     @"page":@"1",
                     @"pagesize":@"10",
                     @"bjid":_detailId,
                     @"ceci":@"",
                     @"xueke":@"",
                     @"pushtime":date,
                     @"V_type":@""
                     };
  
    }else
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"type":@"2",
                     @"page":@"1",
                     @"pagesize":@"10",
                     @"ceci":@"",
                     @"xueke":@"",
                     @"pushtime":date,
                     @"V_type":@""
                     };
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@EduOnlineList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            dataArray = responseObject[@"data"][@"list"];
            [_tableView reloadData];
        }else
        {
            SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
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
#pragma mark pickerView代理
- (void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker *)sender;
    NSDate *_date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EEE"];
    dateString = [dateFormatter stringFromDate:_date];

}

- (void)pickViewShow
{
    _blurView.hidden = NO;
    [self.navigationController.view addSubview:_blurView];
}
#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeWork"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *homeWork = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, TAB_WITHDE-20, 40)];
    homeWork.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    homeWork.font = [UIFont systemFontOfSize:12.0];
    NSString *text = [NSString stringWithFormat:@"%@:%@",dataArray[indexPath.row][@"ZYMC"],dataArray[indexPath.row][@"ZYNR"]];
    homeWork.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    homeWork.attributedText = attributedString;
    [cell addSubview:homeWork];
    
    
    
    return cell;
}



@end
