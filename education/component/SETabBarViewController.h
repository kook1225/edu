//
//  SEHomePageViewController.h
//  Manor_Customer
//
//  Created by zhu jun on 14-9-3.
//  Copyright (c) 2014年 sportsexp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SETabBarViewController : UIViewController

@property (nonatomic,strong) UIView *tabBarView;

- (id)initWithViewController:(NSArray *)viewControllers;
- (void)tabBarViewHidden;
- (void)tabBarViewShow;


@end
