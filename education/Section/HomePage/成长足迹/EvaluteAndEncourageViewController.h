//
//  EvaluteAndEncourageViewController.h
//  education
//
//  Created by zhujun on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "growUpModel.h"

@interface EvaluteAndEncourageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    CGSize labelSize;
}

@property (nonatomic,strong) growUpModel *model;

@end
