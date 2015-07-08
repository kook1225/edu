//
//  EDPhotoDetailContentCell.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhotoDetailContentCell.h"

@implementation EDPhotoDetailContentCell

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
        [self setBackgroundColor:[UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0]];
   
        
        _tabName = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 80, 15)];
        _tabName.font = [UIFont systemFontOfSize:12];
        _tabName.textColor = [UIColor colorWithRed:255/255.0f green:124/255.0f blue:6/255.0f alpha:1.0];
        _tabName.text = @"小丽";
        [self.contentView addSubview:_tabName];
        
        _tabDate = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-128, 8, 100, 20)];
      
        _tabDate.font = [UIFont systemFontOfSize:12];
        _tabDate.textAlignment = NSTextAlignmentRight;
        _tabDate.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        _tabDate.text = @"2015-07-08";
        [self.contentView addSubview:_tabDate];
        
        _tabContent = [[UILabel alloc]initWithFrame:CGRectMake(5,30, SCREENWIDTH-40, 20)];
        _tabContent.textColor = TEXTCOLOR;
        _tabContent.font = [UIFont systemFontOfSize:12];
        _tabContent.numberOfLines = 0;
        
        
        [self.contentView addSubview:_tabContent];
        
        
    }
    return self;
}


- (void)setIntroductionText:(NSString*)text
{
    
    CGRect frame = [self frame];
    float height;
    height =0.0 ;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    _tabContent.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH-40, 500000);
    
    labelSize = [_tabContent sizeThatFits:size];
    
    
    
    //设置label的最大行数
    _tabContent.numberOfLines = 0;
    
    
    _tabContent.frame = CGRectMake(_tabContent.frame.origin.x, _tabContent.frame.origin.y, labelSize.width, labelSize.height);
    
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_tabContent.frame)+5, SCREENWIDTH-30, 1)];
    _lineView.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_lineView];
    //计算出自适应的高度
    frame.size.height = CGRectGetMaxY(_lineView.frame);

    
   
    //计算出自适应的高度
    frame.size.height = CGRectGetMaxY(_lineView.frame);
    height = height +frame.size.height;
    
    NSLog(@"高度是---%f",height);
    self.frame = frame;
}


@end
