//
//  ManageAddViewController.h
//  education
//
//  Created by zhujun on 15/7/7.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipAddListModel.h"

@interface ManageAddViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) int checkRow;
@property (nonatomic,strong) NSArray *dataArray;

@end
