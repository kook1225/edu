//
//  EDMyPhotoCell.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyPhotoCell.h"

@implementation EDMyPhotoCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 30)];
        _dateLabel.font = [UIFont systemFontOfSize:25];
        _dateLabel.textColor = TEXTCOLOR;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dataTime = [formatter stringFromDate:[NSDate date]];
        if ([dataTime isEqualToString:@"2015-07-08"]) {
            _dateLabel.text = @"昨天";
        }else
        {
            NSString *text = @"04六月";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(2, text.length-2)];
            _dateLabel.attributedText = attributedString;
        }
        [self.contentView addSubview:_dateLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, SCREENWIDTH-90, 20)];
        _contentLabel.textColor = TEXTCOLOR;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        
        
        [self.contentView addSubview:_contentLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray
{
    
    CGRect frame = [self frame];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    _contentLabel.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH-90, 500000);
    
    labelSize = [_contentLabel sizeThatFits:size];
    
    
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;
    
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    
    if (imagesArray.count ==0) {
        _zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(_contentLabel.frame)+10, 40, 22)];
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praiseImage"] forState:UIControlStateNormal];
        [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_zanBtn setTitle:@"110" forState:UIControlStateNormal];
        [_zanBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        
        _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, CGRectGetMaxY(_contentLabel.frame)+10, 40, 22)];
        [_msgBtn setBackgroundImage:[UIImage imageNamed:@"evaluteImage"] forState:UIControlStateNormal];
        [_msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_msgBtn setTitle:@"120" forState:UIControlStateNormal];
        [_msgBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
        _msgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [self.contentView addSubview:_msgBtn];
        [self.contentView addSubview:_zanBtn];
        
        

    }else
    {
        for (int i=0; i<imagesArray.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(80+95*i, CGRectGetMaxY(_contentLabel.frame)+10, 75, 75)];
            imgView.contentMode = UIViewContentModeScaleToFill;
            
            imgView.image = [UIImage imageNamed:imagesArray[i]];
            [self.contentView addSubview:imgView];
            
            _zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(imgView.frame)+10, 40, 22)];
            [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praiseImage"] forState:UIControlStateNormal];
            [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            [_zanBtn setTitle:@"110" forState:UIControlStateNormal];
            [_zanBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
            _zanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            
            
            _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, CGRectGetMaxY(imgView.frame)+10, 40, 22)];
            [_msgBtn setBackgroundImage:[UIImage imageNamed:@"evaluteImage"] forState:UIControlStateNormal];
            [_msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            [_msgBtn setTitle:@"120" forState:UIControlStateNormal];
            [_msgBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
            _msgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            
            [self.contentView addSubview:_msgBtn];
            [self.contentView addSubview:_zanBtn];

        }
        
        
       
    }
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_msgBtn.frame)+10, SCREENWIDTH-20, 1)];
    _lineView.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_lineView];
    //计算出自适应的高度
    frame.size.height = CGRectGetMaxY(_lineView.frame);
    
    
    self.frame = frame;
}
@end
