//
//  UserIntroCell.m
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "UserIntroCell.h"

@implementation UserIntroCell

- (void)awakeFromNib {
    _vipImageView = [[UIImageView alloc] init];
    // Initialization code
}

- (void)setData {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",IMG_HOST,[[[[SEUtils getUserInfo] UserDetail] userinfo] YHTX]];
    NSURL *url = [NSURL URLWithString:urlStr];
    [_leftImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"1"]];
    
    _leftImageView.layer.cornerRadius = 5.0f;
    _leftImageView.clipsToBounds = YES;
    
    
    if ([[[[[SEUtils getUserInfo] UserDetail] userinfo] YHLB] intValue] != 3 && [[[[[SEUtils getUserInfo] UserDetail] userinfo] IsVip] intValue] == 1) {
        _nameLabel.textColor = [UIColor colorWithRed:255.0/255.0f green:42.0/255.0f blue:45.0/255.0f alpha:1.000];
    }
    
    if ([[[[[SEUtils getUserInfo] UserDetail] userinfo] YHLB] intValue] == 3) {
        _nameLabel.text = [[[[SEUtils getUserInfo] UserDetail] teacherInfo] JSXM];
        _schoolLabel.text = [[[[SEUtils getUserInfo] UserDetail] schoolInfo] DWMC];
        _classImageView.hidden = YES;
    }
    else {
        _nameLabel.text = [[[[SEUtils getUserInfo] UserDetail] studentInfo] XSXM];
        _schoolLabel.text = [[[[SEUtils getUserInfo] UserDetail] schoolInfo] DWMC];
        _classLabel.text = [NSString stringWithFormat:@"%@%@",[[[[SEUtils getUserInfo] UserDetail] studentInfo] NJMC],[[[[SEUtils getUserInfo] UserDetail] studentInfo] BJMC]];
        
        [_nameLabel sizeToFit];
        
        if ([[[[[SEUtils getUserInfo] UserDetail] userinfo] IsVip] intValue] == 1) {
            if (SCREENHEIGHT > 667) {
                _vipImageView.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame), _nameLabel.frame.origin.y + 3, 15, 15);
            }
            else {
                _vipImageView.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame), _nameLabel.frame.origin.y + 1, 15, 15);
            }
            [_vipImageView setImage:[UIImage imageNamed:@"vip"]];
            [self.contentView addSubview:_vipImageView];
        }
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
