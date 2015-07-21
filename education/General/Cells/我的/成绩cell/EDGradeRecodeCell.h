//
//  EDGradeRecodeCell.h
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUScoreModel.h"
@interface EDGradeRecodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setData:(MUScoreModel *)model;
@end
