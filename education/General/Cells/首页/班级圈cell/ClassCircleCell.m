//
//  ClassCircleCell.m
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ClassCircleCell.h"
#import "AppDelegate.h"
#import "ReplyCell.h"
#import "BottomCell.h"
#import "TopCell.h"

#define IMAGE_HEIGHT ([UIScreen mainScreen].bounds.size.width > 320 ? 95 : 75)

@implementation ClassCircleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
    [_backView removeFromSuperview];
    [_shareBtn removeFromSuperview];
    [_evaluteBtn removeFromSuperview];
    [_replyBtn removeFromSuperview];
    [_tableView removeFromSuperview];
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
        
        // 取消图片点击
        //[_backView addSubview:imageButton];
        
        
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
    
    
    _btnView = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 45, 24)];
    [self.contentView addSubview:_btnView];
    
    _praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [_praiseImageView setImage:[UIImage imageNamed:@"praiseImage"]];
    [_btnView addSubview:_praiseImageView];
    
    _praiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnView.frame.size.width - 18, 5, 15, 15)];
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    _praiseLabel.font = [UIFont systemFontOfSize:11];
    _praiseLabel.text = @"6";
    [_btnView addSubview:_praiseLabel];
    
    _btnView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnView.frame) + 10, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 45, 24)];
    [self.contentView addSubview:_btnView2];
    
    _evaluteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    [_evaluteImageView setImage:[UIImage imageNamed:@"evaluteImage"]];
    [_btnView2 addSubview:_evaluteImageView];
    
    _evaluteLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnView.frame.size.width - 18, 5, 15, 15)];
    _evaluteLabel.textAlignment = NSTextAlignmentCenter;
    _evaluteLabel.font = [UIFont systemFontOfSize:11];
    _evaluteLabel.text = @"26";
    [_btnView2 addSubview:_evaluteLabel];
    
    
    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
    
    _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x + IMAGE_HEIGHT*3 - 30, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
    
    // table
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.scrollEnabled = NO;
    
    
    
    float height = 0.0;
    
    for (int i = 0; i < [replyArray count]; i++) {
        NSString *str = [replyArray objectAtIndex:i];
        
        NSString *merStr = [NSString stringWithFormat:@"%@ : %@",@"上好佳",str];
        
        UIFont *tfont = [UIFont systemFontOfSize:13.0];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
        ////////   ios 7
        CGSize sizeText = [merStr boundingRectWithSize:CGSizeMake(CGRectGetMaxX(_replyBtn.frame) - _contentLabel.frame.origin.x - 10, 50000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        height = height + sizeText.height + 20;
        
    }
    //NSLog(@"height:%g",height);
    
    _tableView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_shareBtn.frame) + 10, CGRectGetMaxX(_replyBtn.frame) - _contentLabel.frame.origin.x + 5, height - [replyArray count]*2 + 25 + 31);
    
    
    [self.contentView addSubview:_tableView];
    
    
    
    //计算出自适应的高度
    frame.size.height = labelSize.height + 66 + _backView.frame.size.height + 5*((([imagesArray count] - 1)/3) + 1) + _shareBtn.frame.size.height + _tableView.frame.size.height;

    
    self.frame = frame;
    
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = @{@"index":[NSNumber numberWithInteger:indexPath.row]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomePageCell"
                                                        object:@"ReplyAction"
                                                      userInfo:dic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.row == [dataArray count] + 1) {
        BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BottomCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else {
        ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replyCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:self options:nil] lastObject];
        }
        
        [cell setIntroductionText:[dataArray objectAtIndex:indexPath.row - 1] name:@"上好佳"labelWidth:_tableView.frame.size.width];
        return cell;
    }
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
