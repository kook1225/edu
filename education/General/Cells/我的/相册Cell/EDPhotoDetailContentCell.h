//
//  EDPhotoDetailContentCell.h
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplysModel.h"

@interface EDPhotoDetailContentCell : UITableViewCell
{
    CGSize labelSize;
}
//tableView里面的属性
@property (nonatomic,strong) UILabel *tabName;
@property (nonatomic,strong) UILabel *tabDate;
@property (nonatomic,strong) UILabel *tabContent;
@property (nonatomic,strong) UIView *lineView;

- (void)setData:(ReplysModel *)model;

- (void)setIntroductionText:(NSString*)text;
@end
