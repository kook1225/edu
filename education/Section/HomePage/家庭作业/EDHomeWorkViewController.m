//
//  EDHomeWorkViewController.m
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDHomeWorkViewController.h"
#import "SETabBarViewController.h"
#import "EDPubulishViewController.h"
#import "EDHomeWorkTableViewCell.h"

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

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;

@property (weak, nonatomic) IBOutlet UILabel *nonDataLabel;

@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@end

@implementation EDHomeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"家庭作业";
    
    if (!IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }

    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    tabBarView = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarView tabBarViewHidden];
    
  

    if([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3)
    {
        _bottomView.hidden = NO;
        _titleLabel.text = [NSString stringWithFormat:@"%@级%@班",_nianji,_banji];
    }else
    {
        _bottomView.hidden = YES;
        _titleLabel.text = [NSString stringWithFormat:@"%@级%@班",[SEUtils getUserInfo].UserDetail.studentInfo.NJMC,[SEUtils getUserInfo].UserDetail.studentInfo.BJMC];
    }
    _publishBtn.layer.cornerRadius = 4.0f;
    _publishBtn.layer.masksToBounds = YES;
    
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
    
    _nonDataLabel.hidden = YES;
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc]init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd EEE"];
    dateString = [formatter_minDate stringFromDate:[NSDate date]];
    _dateLabel.text = dateString;
    
    [_tableView registerClass:[EDHomeWorkTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self AFNRequest:[dateString substringToIndex:10]];
    
    
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

- (IBAction)publishFunction:(id)sender
{
    EDPubulishViewController *publishVC = [[EDPubulishViewController alloc]init];
    publishVC.banji = _detailId;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (IBAction)cancelFunction:(id)sender {
    _blurView.hidden = YES;
}
- (IBAction)sureFunction:(id)sender {
    _blurView.hidden = YES;
    _dateLabel.text = dateString;
    [self AFNRequest:[dateString substringToIndex:10]];
}

- (IBAction)dateTap:(id)sender {
    NSLog(@"1");
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc]init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd EEE"];
    
    NSDate *minDate = [formatter_minDate dateFromString:@"2014-01-01"];
    NSDate *maxDate = [formatter_minDate dateFromString:@"2100-01-01"];
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    [_containView addSubview:datePicker];
    [self pickViewShow];
    
}

- (void)AFNRequest:(NSString *)date
{
    dataArray = [NSMutableArray array];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
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
                     @"page":@"1",
                     @"pagesize":@"999",
                     @"bjid":_detailId,
                     @"pushtime":date
                     };
  
    }else
    {
        pramaters= @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                     @"page":@"1",
                     @"pagesize":@"999",
                     @"bjid":@"",
                     @"pushtime":date
                     };
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@EduOnlineList",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            
            if(responseObject[@"data"][@"list"] == [NSNull null])
            {
                _nonDataLabel.hidden = NO;
                _tableView.hidden = YES;
            }else
            {
                _nonDataLabel.hidden = YES;
                _tableView.hidden = NO;
                dataArray = responseObject[@"data"][@"list"];
                [_tableView reloadData];
            }
           
           
            
            
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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeWork"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *homeWork = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, TAB_WITHDE-20, 40)];
    homeWork.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
    homeWork.font = [UIFont systemFontOfSize:12.0];
    NSString *text = [NSString stringWithFormat:@"%@: %@",dataArray[indexPath.row][@"ZYMC"],dataArray[indexPath.row][@"ZYNR"]];
    homeWork.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    homeWork.attributedText = attributedString;
    
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(TAB_WITHDE-20, 2000) lineBreakMode:NSLineBreakByClipping];
    homeWork.frame = CGRectMake(10, 5, labelSize.width, labelSize.height);
    
    [cell addSubview:homeWork];*/
    
    
    
    
    EDHomeWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     NSString *text = [NSString stringWithFormat:@"%@: %@",dataArray[indexPath.row][@"ZYMC"],dataArray[indexPath.row][@"ZYNR"]];
    [cell setIntroductionText:text height:TAB_WITHDE];
    
    return cell;
}



@end
