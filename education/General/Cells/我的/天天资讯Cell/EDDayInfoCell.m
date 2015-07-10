//
//  EDDayInfoCell.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDDayInfoCell.h"

@implementation EDDayInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setdata
{
    NSString *text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragra = [[NSMutableParagraphStyle alloc]init];
    [paragra setLineSpacing:3.0];
    [attriString addAttribute:NSParagraphStyleAttributeName value:paragra range:NSMakeRange(0, [text length])];
    _contentLabel.attributedText = attriString;
}
@end
