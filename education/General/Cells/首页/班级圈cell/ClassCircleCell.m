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
    [_btnView removeFromSuperview];
    [_btnView2 removeFromSuperview];
    [_shareBtn removeFromSuperview];
    [_evaluteBtn removeFromSuperview];
    [_replyBtn removeFromSuperview];
    [_tableView removeFromSuperview];
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
    dataArray = [NSMutableArray array];
    if ([model.replys count] <= 3) {
        dataArray = [NSMutableArray arrayWithArray:model.replys];
    }
    else {
        for (int i = 0; i < 3; i++) {
            [dataArray addObject:[model.replys objectAtIndex:i]];
        }
    }
    
    
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
                
                /*
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[imagesArray objectAtIndex:i]];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                UIImageView *contentImageView = [[UIImageView alloc] init];
                [contentImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
                
                singleImage = contentImageView.image;
                
                
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
                 */
            }
            
            //[imageView setImage:[UIImage imageNamed:[imagesArray objectAtIndex:i]]];
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[imagesArray objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:urlStr];
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
            
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
        
        if ([imagesArray[0]  isEqual: @""]) {
            _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, 295, 1);
        }
        else {
            _backView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame) + 10, 295, IMAGE_HEIGHT*((([imagesArray count] - 1)/3) + 1));
        }
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        /*
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
         */
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
    
    
    
    if ([imagesArray count] != 0) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
        
        _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x + IMAGE_HEIGHT*3 - 30, CGRectGetMaxY(_backView.frame) + 5*((([imagesArray count] - 1)/3) + 1), 40, 24)];
    }
    else {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_backView.frame) + 5, 40, 24)];
        
        _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x + IMAGE_HEIGHT*3 - 30, CGRectGetMaxY(_backView.frame) + 5, 40, 24)];
    }
    
    
    
    // table
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.scrollEnabled = NO;
    
    
    float height = 0.0;
    
    NSMutableString *titleStr = [NSMutableString string];
    
    
    for (int i = 0; i < [dataArray count]; i++) {
        
        if (i != [dataArray count] - 1) {
            [titleStr appendString:[NSString stringWithFormat:@"%@,",[[[dataArray objectAtIndex:i] author] XM]]];
        }
        else {
            [titleStr appendString:[[[dataArray objectAtIndex:i] author] XM]];
        }
        
        NSString *str = [[dataArray objectAtIndex:i] NR];
        
        NSString *merStr = [NSString stringWithFormat:@"%@ : %@",[[[dataArray objectAtIndex:i] author] XM],str];
        
        UIFont *tfont = [UIFont systemFontOfSize:13.0];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
        ////////   ios 7
        CGSize sizeText = [merStr boundingRectWithSize:CGSizeMake(CGRectGetMaxX(_replyBtn.frame) - _contentLabel.frame.origin.x - 10, 50000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        height = height + sizeText.height + 14;
        
    }
    //NSLog(@"height:%g",height);
    
    _tableView.frame = CGRectMake(_contentLabel.frame.origin.x, CGRectGetMaxY(_shareBtn.frame) + 10, CGRectGetMaxX(_replyBtn.frame) - _contentLabel.frame.origin.x + 5, height - [dataArray count]*2 + 25 + 31);
    [self.contentView addSubview:_tableView];
    
    
    
    //计算出自适应的高度
    if ([imagesArray count] != 0) {
        frame.size.height = labelSize.height + 66 + _backView.frame.size.height + 5*((([imagesArray count] - 1)/3) + 1) + _shareBtn.frame.size.height + _tableView.frame.size.height;
    }
    else {
        frame.size.height = labelSize.height + 66 + _backView.frame.size.height + 5 + _shareBtn.frame.size.height + _tableView.frame.size.height;
    }

    
    self.frame = frame;
    
    
    
    NSArray *titleArray = [NSArray array];
    
    titleArray = [titleStr componentsSeparatedByString:@","];
    // 去重处理
    set = [NSSet setWithArray:titleArray];
    
    setTitle = [NSString string];
    
    setTitle = [[set allObjects] componentsJoinedByString:@","];
    
    [_tableView reloadData];
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
        
        [cell setTitle:setTitle];
        
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
        
        [cell setIntroductionText:[[dataArray objectAtIndex:indexPath.row - 1] NR] name:[[[dataArray objectAtIndex:indexPath.row - 1] author] XM] labelWidth:_tableView.frame.size.width];
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
