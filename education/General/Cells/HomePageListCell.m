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
    [_tableView removeFromSuperview];
    [_shareBtn removeFromSuperview];
    [_evaluteBtn removeFromSuperview];
    [_replyBtn removeFromSuperview];
}

//赋值 and 自动换行,计算出cell的高度
- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray reply:(NSArray *)replyArray index:(NSInteger)indexRow{
    dataArray = [NSArray array];
    dataArray = replyArray;
    
    
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
    
    _backView = [[UIView alloc] init];
    
    for (int i = 0; i < [imagesArray count]; i++) {
        
        if ([imagesArray count] != 1) {
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake((IMAGE_HEIGHT + 5)*(i - 3*(i/3)), (IMAGE_HEIGHT + 5) * (i/3), IMAGE_HEIGHT , IMAGE_HEIGHT)];
            
        }
        else {
            
            
            singleImage = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
            
            /*
             NSLog(@"width-------------%f",singleImage.size.width);
             NSLog(@"height-------------%f",singleImage.size.height);
             */
            
            if (singleImage.size.width >= 220 || singleImage.size.height >= 200) {
                if (singleImage.size.width < singleImage.size.height) {
                    float imageWidth;
                    
                    imageWidth = (singleImage.size.width / singleImage.size.height) * 200;
                    
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth / (singleImage.size.width / singleImage.size.height))];
                }
                else {
                    float imageHeight;
                    
                    imageHeight = 220.0 / (singleImage.size.width / singleImage.size.height);
                    
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (singleImage.size.width / singleImage.size.height) * imageHeight, imageHeight)];
                    
                }
            }
            else {
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, singleImage.size.width, singleImage.size.height)];
            }
        }
        
        [imageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.clipsToBounds = YES;
        
        
        
        UIButton *imageButton = [[UIButton alloc] init];
        
        imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        imageButton.backgroundColor = [UIColor grayColor];
        
        [imageButton setFrame:CGRectMake((IMAGE_HEIGHT + 5)*(i - 3*(i/3)), (IMAGE_HEIGHT + 5) * (i/3), IMAGE_HEIGHT , IMAGE_HEIGHT)];
        imageButton.tag = indexRow*100 +i;
        [imageButton addTarget:self action:@selector(imageIntro:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:imageButton];
        
        
        [_backView addSubview:imageView];
    }
    
    //_backView.backgroundColor = [UIColor grayColor];
    
    if ([imagesArray count] != 1) {
        
        _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, 295, IMAGE_HEIGHT*((([imagesArray count] - 1)/3) + 1));
    }
    else {
        if (singleImage.size.width >= 220 || singleImage.size.height >= 200) {
            if (singleImage.size.width < singleImage.size.height) {
                float imageWidth;
                
                imageWidth = (singleImage.size.width / singleImage.size.height) * 200;
                
                _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, imageWidth, imageWidth / (singleImage.size.width / singleImage.size.height));
            }
            else {
                float imageHeight;
                
                imageHeight = 220.0 / (singleImage.size.width / singleImage.size.height);
                
                _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, (singleImage.size.width / singleImage.size.height) * imageHeight, imageHeight);
            }
        }
        else {
            _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, singleImage.size.width, singleImage.size.height);
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    
    
    // _backView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_backView];
    
    /*
    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
    
    _evaluteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x + IMAGE_HEIGHT*2, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
    [_evaluteBtn setBackgroundImage:[UIImage imageNamed:@"evaluteBtn"] forState:UIControlStateNormal];
    
    _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x + IMAGE_HEIGHT*3 - 30, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
    [_replyBtn setBackgroundImage:[UIImage imageNamed:@"replyBtn"] forState:UIControlStateNormal];
    
    
    [self.contentView addSubview:_shareBtn];
    [self.contentView addSubview:_evaluteBtn];
    [self.contentView addSubview:_replyBtn];
    */
    
    
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
