//
//  EDPhotoDetailCell.m
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDPhotoDetailCell.h"


#define SLIDE ([UIScreen mainScreen].bounds.size.width > 320 ? 20 : 10)

@implementation EDPhotoDetailCell

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
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 50, 50)];
        _headImg.layer.cornerRadius = 4.0f;
        _headImg.layer.masksToBounds = YES;
        _headImg.image = [UIImage imageNamed:@"example1"];
        [self.contentView addSubview:_headImg];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 12, 80, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = TEXTCOLOR;
        //_nameLabel.text = @"小丽";
        [self.contentView addSubview:_nameLabel];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-120, 12, 110, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1.0];
        //_dateLabel.text = @"6月25";
        [self.contentView addSubview:_dateLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70,40, SCREENWIDTH-80, 20)];
        _contentLabel.textColor = TEXTCOLOR;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        
        
        [self.contentView addSubview:_contentLabel];
        
        
    }
    return self;
}

- (void)setData:(ListModel *)model {
    _nameLabel.text = model.author.XM;
    
    NSString *dateStr = [SEUtils formatDateWithString:model.dynamicInfo.TJSJ];
    
    _dateLabel.text = dateStr;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,model.author.YHTX];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
}


- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray comment:(ListModel *)listModel indexPath:(NSInteger)row
{
    lisModel = listModel;
    
    CGRect frame = [self frame];
    dataArray = [NSMutableArray array];
    
    for (int i = 0; i < [listModel.replys count]; i++) {
        [dataArray addObject:[[listModel.replys objectAtIndex:i] NR]];
    }
    
    
    NSMutableString *titleStr = [NSMutableString string];
    
    for (int i = 0; i < [listModel.replys count]; i++) {
        if (i != [dataArray count] - 1) {
            [titleStr appendString:[NSString stringWithFormat:@"%@,",[[[listModel.replys objectAtIndex:i] author] XM]]];
        }
        else {
            [titleStr appendString:[[[listModel.replys objectAtIndex:i] author] XM]];
        }
    }
    
    NSArray *titleArray = [NSArray array];
    
    titleArray = [titleStr componentsSeparatedByString:@","];
    // 去重处理
    set = [NSSet setWithArray:titleArray];
    
    setTitle = [NSString string];
    
    setTitle = [[set allObjects] componentsJoinedByString:@","];
    
    [_tableView reloadData];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    //文本赋值
    _contentLabel.attributedText = attributedString;
    //调节高度
    CGSize size = CGSizeMake(SCREENWIDTH-80, 500000);
    
    labelSize = [_contentLabel sizeThatFits:size];
    
    
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;
    
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    
    if (imagesArray.count == 0) {
        _zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(_contentLabel.frame)+10, 40, 22)];
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praiseImage"] forState:UIControlStateNormal];
        [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        if ([listModel.replys count] > 99) {
            [_zanBtn setTitle:@"99" forState:UIControlStateNormal];
        }
        else {
            [_zanBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[listModel.likes count]] forState:UIControlStateNormal];
        }
        [_zanBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        
        _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(_contentLabel.frame)+10, 40, 22)];
        [_msgBtn setBackgroundImage:[UIImage imageNamed:@"evaluteImage"] forState:UIControlStateNormal];
        [_msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        if ([listModel.replys count] > 99) {
            [_msgBtn setTitle:@"99" forState:UIControlStateNormal];
        }
        else {
            [_msgBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[listModel.replys count]] forState:UIControlStateNormal];
        }
        [_msgBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
        _msgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [self.contentView addSubview:_msgBtn];
        [self.contentView addSubview:_zanBtn];
        
        
        
    }else
    {
        for (int i=0; i<imagesArray.count; i++) {
            UIImageView *imgView;
            if ([imagesArray[0]  isEqual: @""]) {
                imgView = [[UIImageView alloc]initWithFrame:CGRectMake(70+(75+SLIDE)*i, CGRectGetMaxY(_contentLabel.frame)+10, 1, 1)];
            }
            else {
                imgView = [[UIImageView alloc]initWithFrame:CGRectMake(70+(75+SLIDE)*i, CGRectGetMaxY(_contentLabel.frame)+10, 75, 75)];
            }
            
            imgView.userInteractionEnabled = YES;
            
            UIButton *imageButton = [[UIButton alloc] init];
            
            imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if ([imagesArray[0]  isEqual: @""]) {
                [imageButton setFrame:CGRectMake(0, 0, 1 , 1)];
            }
            else {
                [imageButton setFrame:CGRectMake(0, 0, 75 , 75)];
            }
            imageButton.tag = row*100 +i;
            [imageButton addTarget:self action:@selector(imageIntro:) forControlEvents:UIControlEventTouchUpInside];
            
            [imgView addSubview:imageButton];
            
            
            imgView.contentMode = UIViewContentModeScaleToFill;
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[imagesArray objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:urlStr];
            [imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
            
            
            
            
            [self.contentView addSubview:imgView];
            
            _zanBtn = [[UIButton alloc]initWithFrame:CGRectMake(70, CGRectGetMaxY(imgView.frame)+10, 40, 22)];
            [_zanBtn setBackgroundImage:[UIImage imageNamed:@"praiseImage"] forState:UIControlStateNormal];
            [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            [_zanBtn setTitle:@"110" forState:UIControlStateNormal];
            if ([listModel.replys count] > 99) {
                [_zanBtn setTitle:@"99" forState:UIControlStateNormal];
            }
            else {
                [_zanBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[listModel.likes count]] forState:UIControlStateNormal];
            }
            
            [_zanBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
            _zanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            
            
            _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(imgView.frame)+10, 40, 22)];
            [_msgBtn setBackgroundImage:[UIImage imageNamed:@"evaluteImage"] forState:UIControlStateNormal];
            [_msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
            
            if ([listModel.replys count] > 99) {
                [_msgBtn setTitle:@"99" forState:UIControlStateNormal];
            }
            else {
                [_msgBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[listModel.replys count]] forState:UIControlStateNormal];
            }
            
            [_msgBtn setTitleColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0] forState:UIControlStateNormal];
            _msgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            
            [self.contentView addSubview:_msgBtn];
            [self.contentView addSubview:_zanBtn];
            
        }
        
        
        
    }
    
    
    //table
    int height = 0;
    
    for (int i = 0; i < [dataArray count]; i++) {
        NSString *str = [dataArray objectAtIndex:i];
        
       
        
        UIFont *tfont = [UIFont systemFontOfSize:12.0];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
        ////////   ios 7
        CGSize sizeText = [str boundingRectWithSize:CGSizeMake(SCREENWIDTH - 20, 50000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        height = height + sizeText.height + 50;
        
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_msgBtn.frame)+20, SCREENWIDTH-20, height+35)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    
    [_tableView registerClass:[EDPhotoDetailContentCell class] forCellReuseIdentifier:@"contentCell"];
    
    [self.contentView addSubview:_tableView];
    //计算出自适应的高度
    frame.size.height = CGRectGetMaxY(_tableView.frame);
    
    
    self.frame = frame;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row ==0)
    {
        return 35;
    }else
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    
}

- (void)imageIntro:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag:%ld",(long)btn.tag);
    
    NSDictionary *dic = @{@"tag":[NSNumber numberWithInteger:btn.tag]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EDPhotoDetailCell" object:@"seePict" userInfo:dic];
    
}

#pragma mark tableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [lisModel.replys count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        EDPhotoDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"head"];
        if (headCell == nil) {
            headCell = [[[NSBundle mainBundle] loadNibNamed:@"EDPhotoDetailHeadCell" owner:self options:nil] lastObject];
        }
        [headCell setTitle:setTitle];
        
        return headCell;
    }
    
    else {
        EDPhotoDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
        
        [cell setIntroductionText:[dataArray objectAtIndex:indexPath.row - 1]];
        if ([lisModel.replys count] != 0 && ![lisModel.replys[0]  isEqual: @""]) {
            [cell setData:[lisModel.replys objectAtIndex:indexPath.row - 1]];
        }
        
        return cell;
    }
}

@end
