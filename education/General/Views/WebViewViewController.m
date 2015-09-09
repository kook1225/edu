//
//  WebViewViewController.m
//  gaoqiutong
//
//  Created by zhu jun on 15-1-16.
//  Copyright (c) 2015年 sportsexp. All rights reserved.
//

#import "WebViewViewController.h"
#import "SETabBarViewController.h"
#import "AppDelegate.h"

@interface WebViewViewController ()<UIWebViewDelegate> {
    SETabBarViewController *tabBarViewController;
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    tabBarViewController = (SETabBarViewController *)self.navigationController.parentViewController;
    [tabBarViewController tabBarViewHidden];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[[[SEUtils getUserInfo] UserDetail] schoolInfo] DWWZ]]]];
    [_webView loadRequest:request];
    
    // 让网页自适应屏幕大小
    _webView.scalesPageToFit = YES;
    
    _webView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
    // Do any additional setup after loading the view from its nib.
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate Method
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
