//
//  NoticeIntroViewController.m
//  education
//
//  Created by zhujun on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "NoticeIntroViewController.h"
#import "EDInfoDetailModel.h"

@interface NoticeIntroViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation NoticeIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知公告详情";
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    HUD.removeFromSuperViewOnHide = YES;
    
    _msgView.hidden = YES;
    _msgView.layer.cornerRadius = 4.0f;
    _msgView.layer.masksToBounds = YES;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *pramaters = @{@"access_token":[SEUtils getUserInfo].TokenInfo.access_token,
                                @"noticeId":_detailId};
    NSString *urlString = [NSString stringWithFormat:@"%@NoticeDetail",SERVER_HOST];
    
    [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD setHidden:YES];
        NSLog(@"res--%@",responseObject);
        if ([responseObject[@"responseCode"] intValue] ==0) {
            EDInfoDetailModel *detailModel = [[EDInfoDetailModel alloc]initWithDictionary:responseObject[@"data"] error:nil];
            _titleLabel.text = detailModel.ZYMC;
            _timeLabel.text = [detailModel.FBSJ substringToIndex:10];
            
            NSString *path_1 = [[NSBundle mainBundle] pathForResource:@"details" ofType:@"html"];
            NSString *string_1 = [[NSString alloc]initWithContentsOfFile:path_1 encoding:NSUTF8StringEncoding error:nil]; //设置内容
            NSString *newContent_1 = [string_1 stringByReplacingOccurrencesOfString:@"${content}" withString:detailModel.ZYNR];
            [_webView loadHTMLString:newContent_1 baseURL:[[NSBundle mainBundle] bundleURL]];
            _webView.scrollView.scrollEnabled = NO;
            
            
            
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

#pragma mark 常用方法
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hiddenView
{
    _msgView.hidden = YES;
}

#pragma mark webView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    
    
    float height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    NSLog(@"remark高度是---%f",height);
    [_webView setFrame:CGRectMake(10, 75, SCREENWIDTH-20, height+10)];
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(_webView.frame));
    
}



@end
