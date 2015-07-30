//
//  EDDayInfoCell.m
//  education
//
//  Created by Apple on 15/7/1.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDDayInfoCell.h"
#import <UIImageView+AFNetworking.h>

@implementation EDDayInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setdata:(EDInfoArrayModel *)model
{
    _titleLabel.text = model.ZYMC;
    
    _dateLabel.text = [model.FBSJ substringToIndex:10];
    NSString *text = model.ZYNR;
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragra = [[NSMutableParagraphStyle alloc]init];
    [paragra setLineSpacing:3.0];
    [attriString addAttribute:NSParagraphStyleAttributeName value:paragra range:NSMakeRange(0, [text length])];
    _contentLabel.attributedText = attriString;
    
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,model.ZYTP];
    NSURL *url = [NSURL URLWithString:imgString];
    [_headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
   
}
- (void)setDicData:(NSDictionary *)dic
{
    _titleLabel.text = dic[@"ZYMC"];
    
    _dateLabel.text = [dic[@"TJSJ"] substringToIndex:10];
    NSString *text = dic[@"ZYNR"];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragra = [[NSMutableParagraphStyle alloc]init];
    [paragra setLineSpacing:3.0];
    [attriString addAttribute:NSParagraphStyleAttributeName value:paragra range:NSMakeRange(0, [text length])];
    _contentLabel.attributedText = attriString;
    
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,dic[@"ZYTP"]];
    NSURL *url = [NSURL URLWithString:imgString];
    [_headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
}
@end
