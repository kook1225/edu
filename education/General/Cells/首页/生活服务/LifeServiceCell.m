//
//  lifeServiceCell.m
//  education
//
//  Created by zhujun on 15/7/4.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "LifeServiceCell.h"

@implementation LifeServiceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        scale = SCALE;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _mainView.layer.borderColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000].CGColor;
        _mainView.layer.borderWidth = 1;
        [self.contentView addSubview:_mainView];
        
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 2.0 - 15, 110 * scale)];
        [_topImageView setImage:[UIImage imageNamed:@"example1"]];
        [_mainView addSubview:_topImageView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , CGRectGetMaxY(_topImageView.frame) + 5, _topImageView.frame.size.width - 15, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"软皮笔记本一套和恍恍惚惚恍恍惚惚恍恍惚";
        
        [_contentLabel sizeToFit];
        [_mainView addSubview:_contentLabel];
        
        _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mainView.frame) - 40, 100, 20)];
        _oldPriceLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
        _oldPriceLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *oldPrice = @"¥280";
        NSUInteger length=[oldPrice length];
        
        NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)range:NSMakeRange(0,length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000]
        range:NSMakeRange(2, length-2)];
        [_oldPriceLabel setAttributedText:attri];
        [_mainView addSubview:_oldPriceLabel];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mainView.frame) - 24, 10, 20)];
        label.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = @"¥";
        [_mainView addSubview:label];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(_mainView.frame) - 25, 100, 20)];
        _priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
        _priceLabel.font = [UIFont boldSystemFontOfSize:20];
        _priceLabel.text = @"300";
        [_mainView addSubview:_priceLabel];
        
        
        _saledLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mainView.frame.size.width - 110, CGRectGetMaxY(_mainView.frame) - 24, 100, 20)];
        _saledLabel.font = [UIFont systemFontOfSize:12];
        _saledLabel.textAlignment = NSTextAlignmentRight;
        NSString *saledStr = @"已销30件";
        //NSUInteger length2=[oldPrice length];
        
        NSMutableAttributedString *attri2 =[[NSMutableAttributedString alloc]initWithString:saledStr];
        [attri2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45.0/255.0 alpha:1.000]
                      range:NSMakeRange(2, 2)];
        [_saledLabel setAttributedText:attri2];
        [_mainView addSubview:_saledLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
