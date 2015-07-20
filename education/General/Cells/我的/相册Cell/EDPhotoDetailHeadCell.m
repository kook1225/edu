//
//  EDPhotoDetailHeadCell.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhotoDetailHeadCell.h"

@implementation EDPhotoDetailHeadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTitle:(NSString *)title {
    if ([title length] == 0) {
        _titleLabel.text = @"暂无回复";
    }
    else {
        _titleLabel.text = title;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
