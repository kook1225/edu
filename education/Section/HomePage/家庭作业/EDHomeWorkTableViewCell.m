//
//  EDHomeWorkTableViewCell.m
//  education
//
//  Created by Apple on 15/8/18.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDHomeWorkTableViewCell.h"

@implementation EDHomeWorkTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        
        
        [self.contentView addSubview:_contentLabel];
        
        
    }
    return self;

}

-(void)setIntroductionText:(NSString*)text height:(CGFloat)high
{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.contentLabel.text = text;
    _contentLabel.numberOfLines = 0;
    //设置label的最大行数
    
    CGSize size = CGSizeMake(high-20, 1000);
   
    CGSize labelSize = [self.contentLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.contentLabel.frame = CGRectMake(10,5,labelSize.width, labelSize.height);
  
    _contentLabel.numberOfLines =  0;
  
    //计算出自适应的高度
    frame.size.height = CGRectGetMaxY(_contentLabel.frame)+10;
    
    self.frame = frame;
}

@end
