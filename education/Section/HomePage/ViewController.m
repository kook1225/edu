//
//  ViewController.m
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UserIntroCell.h"
#import "ButtonViewCell.h"
#import "HomePageListCell.h"
#import "SETabBarViewController.h"
#import "ClassCircleViewController.h"
#import "LifeServiceViewController.h"
#import "EDPhySicalTestViewController.h"
#import "EDInfomationViewController.h"
#import "EDGradeRecodeViewController.h"
#import "GrowthTrailViewController.h"
#import "EDPrivateNoteViewController.h"
#import "EDHomeWorkViewController.h"
#import "EDSubjectViewController.h"
#import "EDNoticeViewController.h"
#import "EDClassOnlineViewController.h"
#import "SchoolTimeTableViewController.h"
#import "WebViewViewController.h"
#import "ListModel.h"
#import "EDPhotoDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "EDSubjectViewController.h"
#import "EDChooseSubViewController.h"
#import "ClassCircleCell.h"
#import "CheckImageViewController.h"
#import "IQKeyboardManager.h"
#import "EDEditTeacherInfoViewController.h"
#import "EDEditInfoViewController.h"

#define IMAGEHEIGHT ([UIScreen mainScreen].bounds.size.height > 480 ? (160 * ([UIScreen mainScreen].bounds.size.height/568.0)) : 160)
#define USERINTROHEIGHT ([UIScreen mainScreen].bounds.size.height > 480 ? (64 * ([UIScreen mainScreen].bounds.size.height/568.0)) : 64)
#define BUTTONVIEWHEIGHT 204//(204 * ([UIScreen mainScreen].bounds.size.height/568.0))

@interface ViewController ()<UIAlertViewDelegate,UITextFieldDelegate> {
    CGFloat scale;
    NSMutableArray *stringArray;
    NSMutableArray *imagesArray;
    NSMutableArray *bigImageArray;
    UIView *borderView;
    UIButton *imageBtn;
    NSTimer *myTimer;
    NSArray *dataArray;
    NSMutableArray *imageArrays;
    NSString *vipTag;
    
    int replyTag;
    
    SETabBarViewController *tabBarViewController;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UITextField *replyTextField;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scale = SCALE;
    
    _replyView.hidden = YES;
    
    stringArray = [NSMutableArray array];
    imagesArray = [NSMutableArray array];
    bigImageArray = [NSMutableArray array];
    dataArray = [NSArray array];
    
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    
    [[[UIApplication sharedApplication] delegate] window].rootViewController = tabBarViewController;
    
    //拿取banner图片
    [self imageAFNRequest];
    
    // cell
    borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 6 * scale)];
    borderView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.000];

    
    imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, 62, 20 *scale)];
    imageBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [imageBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:6.0/255.0 alpha:1.000] forState:UIControlStateNormal];
    [imageBtn setTitle:@"最新.班级圈" forState:UIControlStateNormal];
    
    imageBtn.layer.cornerRadius = 5.0;
    imageBtn.layer.borderWidth = 1;
    imageBtn.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:6.0/255.0 alpha:1.000].CGColor;
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seePic:)
                                                 name:@"SETabBarViewController"
                                               object:@"seePic"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replyAction:)
                                                 name:@"SETabBarViewController"
                                               object:@"ReplyAction"];
}

- (void)viewWillAppear:(BOOL)animated {
    vipTag = [[[[SEUtils getUserInfo] UserDetail] userinfo] IsVip];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self classCircleApi];
    
    self.navigationController.navigationBar.hidden = YES;
    if ([slideImages count] > 1) {
        [_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];
    }
    [tabBarViewController tabBarViewShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Custom Method
- (void)iconInfo
{
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] == 3) {
        EDEditTeacherInfoViewController *teacherInfoVC = [[EDEditTeacherInfoViewController alloc]init];
        [self.navigationController pushViewController:teacherInfoVC animated:YES];
    }else
    {
        EDEditInfoViewController *editInfoVC = [[EDEditInfoViewController alloc]init];
        [self.navigationController pushViewController:editInfoVC animated:YES];
    }

}
- (void)classCircleApi {
    stringArray = [NSMutableArray array];
    imagesArray = [NSMutableArray array];
    bigImageArray = [NSMutableArray array];
    
    /*
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    */
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamic",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // [HUD hide:YES];
             
             NSError *err;
             
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 
                 dataArray = [ListModel arrayOfModelsFromDictionaries:responseObject[@"data"][@"list"] error:&err];
                 
                 for (int i = 0; i < [dataArray count]; i++) {
                     [stringArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].TPSM];
                     [imagesArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].SLT];
                     [bigImageArray addObject:[[dataArray objectAtIndex:i] dynamicInfo].TPLY];
                 }
                 //NSLog(@"string---------:%@",stringArray);
                 //NSLog(@"array:%@",imagesArray);
                 
                 [_tableView reloadData];
             }
             else {
                 SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
             }
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // [HUD hide:YES];
             if(error.code == -1001)
             {
                 SHOW_ALERT(@"提示", @"网络请求超时");
             }else if (error.code == -1009)
             {
                 SHOW_ALERT(@"提示", @"网络连接已断开");
             }
         }];
}

- (void)imageAFNRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter = @{@"type":@"1"};
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Banner",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:urlStr parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"res---%@",responseObject);
             if ([responseObject[@"responseCode"] intValue] == 0) {
                 slideImages = [responseObject[@"data"] componentsSeparatedByString:@","];
                 // 是否设置回弹效果
                 _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, IMAGEHEIGHT)];
                 _scrollView.tag = 501;
                 _scrollView.delegate = self;
                 _scrollView.bounces = NO;
                 _scrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
                 _scrollView.pagingEnabled = YES;
                 _scrollView.showsHorizontalScrollIndicator = NO;
                 _scrollView.showsVerticalScrollIndicator = NO;
                 
                 
                 if ([slideImages count] > 1) {
                 // 设置scrollView的滚动范围为图片数量+2
                     _scrollView.contentSize = CGSizeMake(SCREENWIDTH*([slideImages count]+2),IMAGEHEIGHT);
                 }
                 else {
                     _scrollView.contentSize = CGSizeMake(SCREENWIDTH,IMAGEHEIGHT);
                 }
                 
                 
                 /*
                  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorSkip)];
                  [_scrollView addGestureRecognizer:tapGestureRecognizer];
                  */
                 
                 // 首次显示的页面
                 
                 UIImageView *imageView = [[UIImageView alloc] init];
                 NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,slideImages[slideImages.count-1]];
                 
                 [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_default"]];
            
                 
//                 [imageView setImage:[UIImage imageNamed:[slideImages objectAtIndex:[slideImages count]-1]]];
                 
                 imageView.frame = CGRectMake(0, 0, SCREENWIDTH, IMAGEHEIGHT);
                 
                 // 把最后一张图片添加到scrollView中
                 [_scrollView addSubview:imageView];
                 
                 
                 if ([slideImages count] > 1) {
                     
                     // 把所有页面都添加到容器中
                     for (int i = 0;i<[slideImages count];i++) {
                         //loop this bit
                         UIImageView *imageView = [[UIImageView alloc] init];
                         imageView.userInteractionEnabled = YES;
                         NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,slideImages[i]];
                          [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_default"]];
//                         [imageView setImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
                         imageView.frame = CGRectMake(SCREENWIDTH*i+SCREENWIDTH, 0, SCREENWIDTH, IMAGEHEIGHT);
                         
                         // 把所有图片一次添加到scrollView中
                         [_scrollView addSubview:imageView];
                     }
                     
                     
                     imageView = [[UIImageView alloc] init];
                     NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,slideImages[0]];
                      [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_default"]];
//                     [imageView setImage:[UIImage imageNamed:[slideImages objectAtIndex:0]]];
                     imageView.frame = CGRectMake(SCREENWIDTH*([slideImages count] + 1), 0, SCREENWIDTH, IMAGEHEIGHT);
                     
                     // 把第一张图片添加到scrollView中
                     [_scrollView addSubview:imageView];
                     
                     
                     // 假定需要滚动的图片数量为5张，编号为1~5，则此时scrollView中对应的图片编号为5，1，2，3，4，5，1共7张.
                     
                     [self performSelector:@selector(updateScrollView) withObject:nil afterDelay:0.0f];
                 }
                 
                 // UIPageControl页面控件
                 
                 // 新建page
                 _page = [[UIPageControl alloc]initWithFrame:CGRectMake(320/2 - 35, IMAGEHEIGHT - 30, 70, 30)];
                 
                 
                 _page.numberOfPages = [slideImages count];
                 _page.currentPage = 0;
                 if (slideImages.count == 1) {
                     _page.hidden = YES;
                 }else
                 {
                     _page.hidden = NO;
                 }
                 
                 _page.pageIndicatorTintColor = [UIColor colorWithWhite:0.7 alpha:0.6];
                 _page.currentPageIndicatorTintColor = [UIColor redColor];
                 
                 [_page addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
                 [_tableView addSubview:_page];

                 [_tableView reloadData];
             }
             else {
                 SHOW_ALERT(@"提示", responseObject[@"responseMessage"]);
             }
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if(error.code == -1001)
             {
                 SHOW_ALERT(@"提示", @"网络请求超时");
             }else if (error.code == -1009)
             {
                 SHOW_ALERT(@"提示", @"网络连接已断开");
             }
         }];

}
- (void)updateScrollView
{
    [myTimer invalidate];
    myTimer = nil;
    //time duration
    NSTimeInterval timeInterval = 5;
    //timer
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                             selector:@selector(handleMaxShowTimer:)
                                             userInfo: nil
                                              repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    // scrollView的偏移量
    CGPoint pt = _scrollView.contentOffset;
    
    NSUInteger count = [slideImages count];
    
    // 如果scrollView的横向偏移量为屏幕宽度的整数倍.
    if(pt.x == SCREENWIDTH * count){
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,IMAGEHEIGHT) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(pt.x+SCREENWIDTH,0,SCREENWIDTH,IMAGEHEIGHT) animated:YES];
    }
}

- (void)schoolTimeTable {
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3 ) {
        EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
        subjectVC.title = @"选择班级";
        subjectVC.type  = @"我的课表";
        [self.navigationController pushViewController:subjectVC animated:YES];
    }else
    {
        SchoolTimeTableViewController *schoolTimeTableVC = [[SchoolTimeTableViewController alloc] init];
        [self.navigationController pushViewController:schoolTimeTableVC animated:YES];
    }
    
}

- (void)myLetter {
    EDPrivateNoteViewController *privateNoteVC = [[EDPrivateNoteViewController alloc]init];
    [self.navigationController pushViewController:privateNoteVC animated:YES];
}

- (void)notice {
    EDNoticeViewController  *notice = [[EDNoticeViewController alloc]init];
    [self.navigationController pushViewController:notice animated:YES];
}

- (void)classSection {
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3 ) {
        EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
        subjectVC.title = @"选择班级";
        subjectVC.type  = @"班级圈";
        [self.navigationController pushViewController:subjectVC animated:YES];
    }else
    {
        ClassCircleViewController *classCircleVC  = [[ClassCircleViewController alloc] init];
        [self.navigationController pushViewController:classCircleVC animated:YES];
    }
    
}

- (void)lifeService {
    LifeServiceViewController *lifeServiceVC = [[LifeServiceViewController alloc] init];
    [self.navigationController pushViewController:lifeServiceVC animated:YES];
}

- (void)introDay {
    EDInfomationViewController *infoVC = [[EDInfomationViewController alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)problem {
    EDChooseSubViewController *chooseSubjectVC = [[EDChooseSubViewController alloc]init];
    chooseSubjectVC.type = @"难点解析";
    chooseSubjectVC.title = @"选择科目";
    [self.navigationController pushViewController:chooseSubjectVC animated:YES];
}

- (void)score {
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3 ) {
        EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
        subjectVC.title = @"选择班级";
        subjectVC.type  = @"成绩档案";
        [self.navigationController pushViewController:subjectVC animated:YES];
    }else
    {
        if ([vipTag intValue] == 1) {
            EDGradeRecodeViewController *gradeVC = [[EDGradeRecodeViewController alloc]init];
            [self.navigationController pushViewController:gradeVC animated:YES];
        }
        else {
            EDGradeRecodeViewController *gradeVC = [[EDGradeRecodeViewController alloc]init];
            [self.navigationController pushViewController:gradeVC animated:YES];
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"VIP会员尊享家庭作业、成长足迹、成绩档案、在线视频四大核心业务。您还不是会员，赶紧去开通吧!" delegate:self cancelButtonTitle:@"返回首页" otherButtonTitles:@"成为VIP", nil];
            alert.tag = 201;
            [alert show];
             */
        }
    }
    
}

- (void)homework {
    
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3 ) {
        EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
        subjectVC.title = @"选择班级";
        subjectVC.type  = @"家庭作业";
        [self.navigationController pushViewController:subjectVC animated:YES];
    }else
    {
        if ([vipTag intValue] == 1) {
            EDHomeWorkViewController *homeWorkVC = [[EDHomeWorkViewController alloc]init];
            [self.navigationController pushViewController:homeWorkVC animated:YES];
        }
        else {
            EDHomeWorkViewController *homeWorkVC = [[EDHomeWorkViewController alloc]init];
            [self.navigationController pushViewController:homeWorkVC animated:YES];
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"VIP会员尊享家庭作业、成长足迹、成绩档案、在线视频四大核心业务。您还不是会员，赶紧去开通吧!" delegate:self cancelButtonTitle:@"返回首页" otherButtonTitles:@"成为VIP", nil];
            alert.tag = 201;
            [alert show];
             */
        }
    }
    
}

- (void)growUp {
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3 ) {
        EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
        subjectVC.title = @"选择班级";

        subjectVC.type  = @"成长足迹";
        [self.navigationController pushViewController:subjectVC animated:YES];
    }else
        {
        if ([vipTag intValue] == 1) {

            GrowthTrailViewController *growthTrailVC = [[GrowthTrailViewController alloc] init];
            [self.navigationController pushViewController:growthTrailVC animated:YES];
        }
        else {
            GrowthTrailViewController *growthTrailVC = [[GrowthTrailViewController alloc] init];
            [self.navigationController pushViewController:growthTrailVC animated:YES];
         /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"VIP会员尊享家庭作业、成长足迹、成绩档案、在线视频四大核心业务。您还不是会员，赶紧去开通吧!" delegate:self cancelButtonTitle:@"返回首页" otherButtonTitles:@"成为VIP", nil];
            alert.tag = 201;
            [alert show];
          */
        }

    }

}

- (void)body {
    if ([[SEUtils getUserInfo].UserDetail.userinfo.YHLB intValue] ==3 ) {
        EDSubjectViewController *subjectVC = [[EDSubjectViewController alloc]init];
        subjectVC.title = @"选择班级";
        subjectVC.type  = @"体质体能";
        [self.navigationController pushViewController:subjectVC animated:YES];
    }else
    {
        EDPhySicalTestViewController *physicalVC = [[EDPhySicalTestViewController alloc]init];
        [self.navigationController pushViewController:physicalVC animated:YES];
    }
    
}

- (void)courseOnLine {
     if ([vipTag intValue] == 1) {
//            EDChooseSubViewController *chooseSubjectVC = [[EDChooseSubViewController alloc]init];
//            chooseSubjectVC.type = @"在线课堂";
//            [self.navigationController pushViewController:chooseSubjectVC animated:YES];
         EDClassOnlineViewController *classOnlineVC = [[EDClassOnlineViewController alloc]init];
         [self.navigationController pushViewController:classOnlineVC animated:YES];
        }
        else {
            EDClassOnlineViewController *classOnlineVC = [[EDClassOnlineViewController alloc]init];
            [self.navigationController pushViewController:classOnlineVC animated:YES];
           
            /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"VIP会员尊享家庭作业、成长足迹、成绩档案、在线视频四大核心业务。您还不是会员，赶紧去开通吧!" delegate:self cancelButtonTitle:@"返回首页" otherButtonTitles:@"成为VIP", nil];
            alert.tag = 201;
            [alert show];
             */
        }
    
}

- (void)skipWeb {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[SEUtils getUserInfo] UserDetail] schoolInfo] DWWZ]]]];
    
    /*
    WebViewViewController *webViewVC = [[WebViewViewController alloc] init];
    [self.navigationController pushViewController:webViewVC animated:YES];
     */
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 1) {
            LifeServiceViewController *lifeServiceVC = [[LifeServiceViewController alloc] init];
            lifeServiceVC.vipStr = @"成为vip";
            [self.navigationController pushViewController:lifeServiceVC animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_replyTextField resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return IMAGEHEIGHT;
    }
    else if (indexPath.row == 1) {
        return USERINTROHEIGHT;
    }
    else if (indexPath.row == 2) {
        return BUTTONVIEWHEIGHT * scale;
    }
    else if (indexPath.row == 3) {
        return 32 * scale;
    }
    else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height + 10;
    }
    
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4 + [stringArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:_scrollView];
        
        return cell;
    }
    else if (indexPath.row == 1) {
        UserIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userIntroCell"];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserIntroCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setData];
        [cell.schoolBtn addTarget:self action:@selector(skipWeb) forControlEvents:UIControlEventTouchUpInside];
        cell.leftImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconInfo)];
        [cell.leftImageView addGestureRecognizer:iconTap];
        return cell;
    }
    else if (indexPath.row == 2) {
        ButtonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonViewCell"];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ButtonViewCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell vipUser:vipTag];
        
        [cell.btn1 addTarget:self action:@selector(schoolTimeTable) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(myLetter) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(classSection) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(lifeService) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(introDay) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(problem) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn11 addTarget:self action:@selector(score) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(homework) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn10 addTarget:self action:@selector(growUp) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(body) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn12 addTarget:self action:@selector(courseOnLine) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:imageBtn];
        [cell.contentView addSubview:borderView];
        return cell;
    }
    else {
     
        ClassCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCircleCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassCircleCell" owner:self options:nil] lastObject];
        }
        
        imageArrays = [NSMutableArray array];
        
        if ([imagesArray count] != 0) {
            
            NSString *imageStr = [imagesArray objectAtIndex:indexPath.row - 4];
            
            imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
        }
        else {
            imageArrays =[NSMutableArray arrayWithArray:@[]];
        }
        
        
        //@[@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊a",@"范德萨范德萨范德萨范德萨大叔大叔的"]
        
        if ([stringArray count] != 0) {
            [cell setIntroductionText:[stringArray objectAtIndex:[indexPath row] - 4] image:imageArrays reply:[dataArray objectAtIndex:indexPath.row - 4] index:indexPath.row - 4];
        }
        
        [cell setData:[dataArray objectAtIndex:indexPath.row - 4]];
        cell.priBtn.tag = 400 + indexPath.row - 4;
        [cell.priBtn addTarget:self action:@selector(evalutePri:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.rlyBtn.tag = 500 + indexPath.row - 4;
        [cell.rlyBtn addTarget:self action:@selector(replyBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.homePage = @"首页";
        
        return cell;
    }
}

// 点赞
- (void)evalutePri:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag----%d",(int)btn.tag - 400);
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"加载中...";
    HUD.removeFromSuperViewOnHide = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter;
    
    parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                  @"dynamicId":[[[dataArray objectAtIndex:btn.tag - 400] dynamicInfo] ID]};
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamicLike",SERVER_HOST];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [HUD hide:YES];
              
              if ([responseObject[@"responseCode"] intValue] == 0) {
                  SHOW_ALERT(@"提示", @"点赞成功");
                  [self classCircleApi];
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

// 回复
- (void)replyBtn:(id)sender {
    
    replyTag = 0;
    
    UIButton *btn = (UIButton *)sender;
    replyTag = (int)btn.tag - 500;
    _replyView.hidden = NO;
    [_replyTextField becomeFirstResponder];
    
}

-(void)seePic:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    
    CheckImageViewController *checkImageVC = [[CheckImageViewController alloc] init];
    
    NSString *imageStr = [bigImageArray objectAtIndex:[dic[@"tag"] intValue]/100];
    imageArrays = [NSMutableArray arrayWithArray:[imageStr componentsSeparatedByString:@","]];
    
    checkImageVC.dataArray = imageArrays;
    checkImageVC.page = [dic[@"tag"] intValue]%100;
    
    [self.navigationController pushViewController:checkImageVC animated:YES];
}

-(void)replyAction:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    EDPhotoDetailViewController *photoDetail = [[EDPhotoDetailViewController alloc]init];
    photoDetail.model = [dataArray objectAtIndex:[dic[@"index"] intValue]];
    photoDetail.xxId = [[[dataArray objectAtIndex:[dic[@"index"] intValue]] dynamicInfo] ID];
    [self.navigationController pushViewController:photoDetail animated:YES];
}

- (IBAction)replyButton:(id)sender {
    //NSLog(@"ddddddddd:%d",replyTag);
    if ([_replyTextField.text length] == 0) {
        SHOW_ALERT(@"提示", @"评论不能为空");
    }
    else {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = @"加载中...";
        HUD.removeFromSuperViewOnHide = YES;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter;
        
        parameter = @{@"access_token":[[[SEUtils getUserInfo] TokenInfo] access_token],
                      @"dynamicId":[[[dataArray objectAtIndex:replyTag] dynamicInfo] ID],
                      @"content":_replyTextField.text};
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@ClassZoneDynamicReply",SERVER_HOST];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlStr parameters:parameter
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [HUD hide:YES];
                  
                  if ([responseObject[@"responseCode"] intValue] == 0) {
                      SHOW_ALERT(@"提示", @"评论成功");
                      _replyView.hidden = YES;
                      [_replyTextField resignFirstResponder];
                      [self classCircleApi];
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

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _replyView.hidden = YES;
    [_replyTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _replyView.hidden = YES;
    [_replyTextField resignFirstResponder];
    return YES;
}


#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if (scrollView.tag == 501) {
        
        
        int currentPage = (_scrollView.contentOffset.x - _scrollView.frame.size.width / ([slideImages count])) / _scrollView.frame.size.width + 1;
        NSLog(@"%d",currentPage);
        if (currentPage==0) {
            [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH*[slideImages count], 0, SCREENWIDTH, IMAGEHEIGHT) animated:NO];
        }
        else if (currentPage==([slideImages count]+1)) {
            [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, IMAGEHEIGHT) animated:NO];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender

{
    if (sender.tag == 501) {
        int page = _scrollView.contentOffset.x/SCREENWIDTH-1;
        //int page = _scrollView.contentOffset.x/320;
        _page.currentPage = page;
    }
}

-(void)pageAction
{
    int page = (int)_page.currentPage;
    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH * (page+1), 0)];
    [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH * (page+1), 0, SCREENWIDTH, IMAGEHEIGHT) animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
