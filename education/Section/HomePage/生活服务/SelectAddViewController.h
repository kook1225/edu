//
//  SelectAddViewController.h
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAddViewControllerDelegate <NSObject>

- (void)selectedAdd:(int)row;

@end

@interface SelectAddViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) int checkRow;
@property (nonatomic,weak) id<SelectAddViewControllerDelegate> delegate;

@end
