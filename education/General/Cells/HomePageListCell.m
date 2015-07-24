//
//  HomePageListCell.m
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "HomePageListCell.h"
#import "AppDelegate.h"

#define IMAGE_HEIGHT ([UIScreen mainScreen].bounds.size.width > 320 ? 95 : 75)

@implementation HomePageListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
    [_backView removeFromSuperview];
    [_shareBtn removeFromSuperview];
    [_evaluteBtn removeFromSuperview];
    [_replyBtn removeFromSuperview];
}

- (void)setData:(ListModel *)model {
    _nameLabel.text = model.author.XM;
    
    NSString *dateStr = [SEUtils formatDateWithString:model.dynamicInfo.TJSJ];
    
    _dateLabel.text = dateStr;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,model.author.YHTX];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
}

//赋值 and 自动换行,计算出cell的高度
- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray reply:(ListModel *)model index:(NSInteger)indexRow{
    row = indexRow;
    
    imageArray = [NSArray array];
    
    imageArray = imagesArray;
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    _contentLabel.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH - 73, 500000);
    
    labelSize = [_contentLabel sizeThatFits:size];
    
    
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;
    
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, 0, 0)];
    
    
    if ([imagesArray count] != 0) {
        for (int i = 0; i < [imagesArray count]; i++) {
            
            if ([imagesArray count] != 1) {
                
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake((IMAGE_HEIGHT + 5)*(i - 3*(i/3)), (IMAGE_HEIGHT + 5) * (i/3), IMAGE_HEIGHT , IMAGE_HEIGHT)];
                
            }
            else {
                if ([imagesArray[0]  isEqual: @""]) {
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                }
                else {
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_HEIGHT, IMAGE_HEIGHT)];
                }
                
            }
            
            //[imageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[imagesArray objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:urlStr];
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            imageView.clipsToBounds = YES;
            
            
            
            UIButton *imageButton = [[UIButton alloc] init];
            
            imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //imageButton.backgroundColor = [UIColor grayColor];
            
            if ([imagesArray[0]  isEqual: @""]) {
                [imageButton setFrame:CGRectMake((IMAGE_HEIGHT + 5)*(i - 3*(i/3)), (IMAGE_HEIGHT + 5) * (i/3), 1 , 1)];
            }
            else {
                [imageButton setFrame:CGRectMake((IMAGE_HEIGHT + 5)*(i - 3*(i/3)), (IMAGE_HEIGHT + 5) * (i/3), IMAGE_HEIGHT , IMAGE_HEIGHT)];
            }
            imageButton.tag = indexRow*100 +i;
            [imageButton addTarget:self action:@selector(imageIntro:) forControlEvents:UIControlEventTouchUpInside];
            
            //[_backView addSubview:imageButton];
            
            
            [_backView addSubview:imageView];
        }
        
        //_backView.backgroundColor = [UIColor grayColor];
        
        if ([imagesArray[0]  isEqual: @""]) {
            _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, 295, 1);
        }
        else {
            _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, 295, IMAGE_HEIGHT*((([imagesArray count] - 1)/3) + 1));
        }
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    
    // _backView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_backView];
    
    if ([imagesArray count] != 0) {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 45, 24)];
    }
    else {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5, 45, 24)];
    }
    [self.contentView addSubview:_btnView];
    
    _praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [_praiseImageView setImage:[UIImage imageNamed:@"praiseImage"]];
    [_btnView addSubview:_praiseImageView];
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnView.frame.size.width - 18, 5, 15, 15)];
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    _praiseLabel.font = [UIFont systemFontOfSize:11];
    if ([model.likes count] > 99) {
        _praiseLabel.text = @"99";
    }
    else {
        _praiseLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[model.likes count]];
    }
    [_btnView addSubview:_praiseLabel];
    
    
    _priBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [_btnView addSubview:_priBtn];
    
    
    if ([imagesArray count] != 0) {
        _btnView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnView.frame) + 10, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 45, 24)];
    }
    else {
        _btnView2 = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5, 45, 24)];
    }
    
    
    [self.contentView addSubview:_btnView2];
    
    _evaluteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [_evaluteImageView setImage:[UIImage imageNamed:@"evaluteImage"]];
    [_btnView2 addSubview:_evaluteImageView];
    
    _evaluteLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnView.frame.size.width - 18, 5, 15, 15)];
    _evaluteLabel.textAlignment = NSTextAlignmentCenter;
    _evaluteLabel.font = [UIFont systemFontOfSize:11];
    if ([model.replys count] > 99) {
        _evaluteLabel.text = @"99";
    }
    else {
        _evaluteLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[model.replys count]];
    }
    [_btnView2 addSubview:_evaluteLabel];
    
    _rlyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [_btnView2 addSubview:_rlyBtn];
    
    
    //计算出自适应的高度
    frame.size.height = labelSize.height + 66 + _backView.frame.size.height + 5*((([imagesArray count] - 1)/3) + 1);
    
    self.frame = frame;
    
}


- (void)imageIntro:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag:%ld",(long)btn.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
