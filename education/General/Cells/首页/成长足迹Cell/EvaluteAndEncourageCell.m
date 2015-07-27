//
//  EvaluteAndEncourageCell.m
//  education
//
//  Created by zhujun on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EvaluteAndEncourageCell.h"

@implementation EvaluteAndEncourageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(growUpModel *)model {
    _dateLabel.text = model.FBSJ;
}

- (void)setIntroductionText:(NSString*)text name:(NSString *)name {
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    NSLog(@"frame:%f",frame.origin.x);
    
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;
    
    NSString *replyStr = [NSString stringWithFormat:@"%@回复 : %@",name,text];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, replyStr.length)];
    
    //文本赋值
    _contentLabel.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH-20, 500000);
    
    labelSize = [_contentLabel sizeThatFits:size];
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    //_borderView.frame = CGRectMake(0, labelSize.height + 5, SCREENWIDTH, 1);
    
    _dateLabel.frame = CGRectMake(10, CGRectGetMaxY(_contentLabel.frame), _dateLabel.frame.size.width, _dateLabel.frame.size.height);
    
    //计算出自适应的高度
    frame.size.height = labelSize.height + 6 + _dateLabel.frame.size.height;
    
    self.frame = frame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
