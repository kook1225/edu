//
//  TabBarViewController.m
//  Manor_Merchant
//
//  Created by LinQ_Mac on 14-8-13.
//  Copyright (c) 2014年 LinQ_Mac. All rights reserved.
//

#import "SETabBarViewController.h"
#import "AppDelegate.h"

#define TAB_BAR_VIEW_HEIGHT ([UIScreen mainScreen].bounds.size.width >= 768 ? 50 : 50)

@interface SETabBarViewController ()
{
    CGFloat tabBarViewHeight;
    UIView * contentView;
    NSArray * viewControllerArray;
    UIView * lineView;
    int tag;
    int index;
}

@end

@implementation SETabBarViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (id)initWithViewController:(NSArray *)viewControllers
{
    if (self = [super init]) {
        tag = 400;
        
      
        
        // reverseObjectEnumerator 倒序获取数组
        viewControllerArray = [[viewControllers reverseObjectEnumerator]allObjects];
        
        
        _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds)-TAB_BAR_VIEW_HEIGHT, SCREENWIDTH, TAB_BAR_VIEW_HEIGHT)];
        

        NSLog(@"bounds:%f",CGRectGetMaxY(self.view.bounds));
        
        [_tabBarView setBackgroundColor:[UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000]];
        
        
        if ([UIDevice currentDevice].systemVersion.intValue >= 7)
        {
            contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, CGRectGetHeight(self.view.bounds)-TAB_BAR_VIEW_HEIGHT)];
        }else{
            contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, CGRectGetHeight(self.view.bounds)-TAB_BAR_VIEW_HEIGHT)];
        }
        
        
        
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1];
        

        
        float buttonWith = SCREENWIDTH/viewControllerArray.count;
        float buttonHeight = TAB_BAR_VIEW_HEIGHT/5*4;
        
        NSArray *arrayBtnImage;
        NSArray *arrayBtnHighLight;
        
        
        
        if (SCREENHEIGHT <= 568) {
            arrayBtnImage = @[@"homePage5s_un",@"contactIndex5s_un",@"userCenter5s_un",@"setting5s_un"];
            arrayBtnHighLight = @[@"homePage5s",@"contactIndex5s",@"userCenter5s",@"setting5s"];
        }
        else {
            if (SCREENHEIGHT == 667) {
                arrayBtnImage = @[@"homePage_un",@"contactIndex_un",@"userCenter_un",@"setting_un"];
                arrayBtnHighLight = @[@"homePage",@"contactIndex",@"userCenter",@"setting"];
            }
            else {
                arrayBtnImage = @[@"homePage6p_un",@"contactIndex6p_un",@"userCenter6p_un",@"setting6p_un"];
                arrayBtnHighLight = @[@"homePage6p",@"contactIndex6p",@"userCenter6p",@"setting6p"];
            }
        }
        
        
        
        for (int i=0; i<viewControllerArray.count; i++) {
            UIButton * tabBarButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonWith*i, 5, buttonWith, buttonHeight)];
            tabBarButton.tag = 400+i;
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarButton setBackgroundImage:[UIImage imageNamed:[arrayBtnImage objectAtIndex:i]] forState:UIControlStateNormal];
            [tabBarButton setBackgroundImage:[UIImage imageNamed:[arrayBtnHighLight objectAtIndex:i]] forState:UIControlStateSelected];
            
            if (i==0) {
                [tabBarButton setSelected:YES];
            }
            // 防止按钮同时触发
            [tabBarButton setExclusiveTouch:YES];
            
            [_tabBarView addSubview:tabBarButton];
            
        }
        
        // 首页显示
        UIViewController * destinationController = [viewControllerArray objectAtIndex:viewControllerArray.count-1];
        [self addChildViewController:destinationController];
        [destinationController didMoveToParentViewController:self];
        [contentView addSubview:destinationController.view];
        
        
        [_tabBarView addSubview:lineView];
        [self.view addSubview:contentView];
        [self.view addSubview:_tabBarView];
        
        
    }
    return self;
}

- (void)tabBarButtonClick:(UIButton *)button
{
    [button setSelected:YES];
    for (int i =400; i<viewControllerArray.count+400; i++) {
        UIButton * btn = (UIButton *)[_tabBarView viewWithTag:i];
        if (i!= button.tag) {
            [btn setSelected:NO];
        }
    }
    
    
    if (index != button.tag - 400) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SETabBarViewController" object:@"RefreshView" userInfo:@{}];
   
        
        UIViewController *sourceController = [viewControllerArray objectAtIndex:viewControllerArray.count-1-index];
        UIViewController *destinationController = [viewControllerArray objectAtIndex:viewControllerArray.count-1-(button.tag-400)];
        [self addChildViewController:destinationController];
        [destinationController didMoveToParentViewController:self];
        [self transitionFromViewController:sourceController toViewController:destinationController duration:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
        } completion:^(BOOL finished) {
            index = (int)button.tag - 400;
            
            [sourceController willMoveToParentViewController:nil];
            [sourceController removeFromParentViewController];
            
        }];
    }
    
    tag = (int)button.tag;
    NSLog(@"tag:%d",tag);
    
}


- (void)tabBarViewHidden
{
    [UIView animateWithDuration:0.2 animations:^{
        _tabBarView.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds), 320, TAB_BAR_VIEW_HEIGHT);
        contentView.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetHeight(self.view.bounds));
    }];
}

- (void)tabBarViewShow
{
    [UIView animateWithDuration:0.2 animations:^{
        _tabBarView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-TAB_BAR_VIEW_HEIGHT, SCREENWIDTH, TAB_BAR_VIEW_HEIGHT);
        contentView.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetHeight(self.view.bounds)-TAB_BAR_VIEW_HEIGHT);
    }];
 
}



@end