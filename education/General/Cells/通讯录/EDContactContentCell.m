//
//  EDContactContentCell.m
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDContactContentCell.h"

@implementation EDContactContentCell

- (void)awakeFromNib {
    // Initialization code
    _contactImg.layer.cornerRadius = 4.0f;
    _contactImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
