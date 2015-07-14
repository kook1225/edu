//
//  FillInforViewController.h
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FillInforViewControllerDelegate <NSObject>

- (void)Login;

@end

@interface FillInforViewController : UIViewController

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *pwd;
@property (nonatomic,weak) id<FillInforViewControllerDelegate> delegate;

@end
