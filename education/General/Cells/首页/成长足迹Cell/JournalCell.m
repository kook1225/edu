//
//  JournalCell.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JournalCell.h"

@implementation JournalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData {
    _mainView.layer.borderColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000].CGColor;
    _mainView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
