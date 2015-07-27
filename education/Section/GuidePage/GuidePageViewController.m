//
//  GuidePageViewController.m
//  gaoqiutong
//
//  Created by zhu jun on 15-1-20.
//  Copyright (c) 2015年 sportsexp. All rights reserved.
//

#import "GuidePageViewController.h"
#import "ViewController.h"
#import "EDContactViewController.h"
#import "EDSettingViewController.h"
#import "MineViewController.h"
#import "SETabBarViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "SEUtils.h"

@interface GuidePageViewController ()<UIScrollViewDelegate> {
    NSArray *imagesArray;
    UISwipeGestureRecognizer *swipe;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GuidePageViewController

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    imagesArray = [NSArray array];
  
    
    // 是否设置回弹效果
    _scrollView.bounces = NO;
    
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    //_scrollView.contentSize = CGSizeMake(1280,568);
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*4,480);
    }
    else {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*4,SCREENHEIGHT);
    }
    
    _scrollView.pagingEnabled = YES;
    
    
    
    if ([UIScreen mainScreen].bounds.size.height >= 568) {
        slideImages = [[NSMutableArray alloc]initWithObjects:@"guidePage1",@"guidePage2",@"guidePage3",@"guidePage4", nil];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 480) {
        slideImages = [[NSMutableArray alloc]initWithObjects:@"guidePage11",@"guidePage22",@"guidePage33",@"guidePage44", nil];
    }
    
    
    
    // 首次显示的页面
    
    UIImageView *imageView = [[UIImageView alloc]
                              
                              initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:0]]];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        imageView.frame = CGRectMake(0, 0, SCREENWIDTH, 480);
    }
    else {
        imageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    }
    
    [_scrollView addSubview:imageView];
    
    
    
    // 把所有页面都添加到容器中
    for (int i = 0;i<[slideImages count];i++) {
        
        //loop this bit
        
        UIImageView *imageView = [[UIImageView alloc]
                                  
                                  initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
        
        //imageView.frame = CGRectMake(320*i, 0, 320, 568);
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            imageView.frame = CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, 480);
        }
        else {
            imageView.frame = CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT);
        }
        
        
        imageView.userInteractionEnabled = YES;
        
        [_scrollView addSubview:imageView];
        
        
    }
    
    
    // UIPageControl页面控件
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake(120, 432, 70, 30)];
    }
    else {
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake(120, 520, 70, 30)];
    }
    
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    _page.pageIndicatorTintColor = [UIColor grayColor];
    
    _page.numberOfPages = 4;
    _page.currentPage = 0;
    
    
    [_page addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_page];
    
    _page.hidden = YES;
    
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _scrollView.contentOffset.x/SCREENWIDTH;
    _page.currentPage = page;
    
    if (_page.currentPage == 3) {
        _scrollView.bounces = YES;
        
        UIButton *button;
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 4 - (SCREENWIDTH - 132)/2 - 132, 365, 132, 40)];
        }
        else {
            button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 4 - (SCREENWIDTH - 132)/2 - 132, 405 * (SCREENHEIGHT/568.0), 132, 40)];
        }
        
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(tabBarPage) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];

    }
    
    if (_scrollView.contentOffset.x > SCREENWIDTH * 3) {
        //_page.hidden = YES;

        [self tabBarPage];
        

         
        // 设置scrollView是否能够滑动
        //_scrollView.scrollEnabled = NO;
    }
   
}



- (void)registerBtn {
    /*
    SERegisterViewController *registerViewController = [[SERegisterViewController alloc] init];
    registerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    registerViewController.guidePage = YES;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
    */
}

- (void)tabBarPage {
    ViewController *viewController = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    EDContactViewController *contactVC = [[EDContactViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:contactVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    EDSettingViewController *settingVC = [[EDSettingViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    SETabBarViewController *tabBarVC = [[SETabBarViewController alloc] initWithViewController:@[nav,nav2,nav3,nav4]];
    
    //重新设置根根视图
    [[[UIApplication sharedApplication] delegate] window].rootViewController = tabBarVC;
    
    tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:tabBarVC animated:YES completion:nil];
    
    
    /*
    AdPageViewController *adPageVC = [[AdPageViewController alloc] init];
    adPageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:adPageVC animated:YES completion:nil];
     */
}

-(void)pageAction

{
    int page = (int)_page.currentPage;
    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH * (page+1), 0)];
}


- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

@end