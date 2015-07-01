//
//  AppDelegate.h
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCALE [UIScreen mainScreen].bounds.size.height > 568 ? ([UIScreen mainScreen].bounds.size.height/568.0) : 1

#define SHOW_ALERT(title,info)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
[alert show];


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

