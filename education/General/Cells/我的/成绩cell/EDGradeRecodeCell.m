//
//  EDGradeRecodeCell.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDGradeRecodeCell.h"

@implementation EDGradeRecodeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(MUScoreModel *)model
{
    _nameLabel.text = model.KSMC;
    _dateLabel.text = [model.KSSJ substringToIndex:10];
}
@end
