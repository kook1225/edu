//
//  ReplyCell.m
//  neighborhood
//
//  Created by zhu jun on 15/5/13.
//  Copyright (c) 2015年 sportsexp. All rights reserved.
//

#import "ReplyCell.h"
#import "AppDelegate.h"

@implementation ReplyCell

- (void)setIntroductionText:(NSString*)text name:(NSString *)name labelWidth:(float)width{
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //NSLog(@"frame:%f",frame.origin.x);
    
    //设置label的最大行数
    _replyLabel.numberOfLines = 0;
    
    NSString *replyStr = [NSString stringWithFormat:@"%@ : %@",name,text];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, replyStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:6.0/255.0 alpha:1.000] range:NSMakeRange(0, [name length] + 3)];
    
    //文本赋值
    _replyLabel.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(width-10, 500000);
    
    labelSize = [_replyLabel sizeThatFits:size];
    
    _replyLabel.frame = CGRectMake(_replyLabel.frame.origin.x, _replyLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    _borderView.frame = CGRectMake(0, labelSize.height + 5, SCREENWIDTH, 1);
    
    //计算出自适应的高度
    frame.size.height = labelSize.height + 6;
    
    self.frame = frame;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
