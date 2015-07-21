//
//  TopCell.m
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTitle:(NSString *)name {
    if ([name length] == 0) {
        _titleLabel.text = @"暂无回复";
    }
    else {
        _titleLabel.text = name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
