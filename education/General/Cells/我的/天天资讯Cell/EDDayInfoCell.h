//
//  EDDayInfoCell.h
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDInfoArrayModel.h"

@interface EDDayInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setdata:(EDInfoArrayModel *)model;
@end
