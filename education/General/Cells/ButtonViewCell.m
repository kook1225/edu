//
//  ButtonViewCell.m
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "ButtonViewCell.h"

@implementation ButtonViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)vipUser:(BOOL)vip {
    
    CGFloat scale = SCALE;
    
    if (!vip) {
        [_btn9 setBackgroundImage:[UIImage imageNamed:@"btn9v"] forState:UIControlStateNormal];
        [_btn10 setBackgroundImage:[UIImage imageNamed:@"btn10v"] forState:UIControlStateNormal];
        [_btn11 setBackgroundImage:[UIImage imageNamed:@"btn11v"] forState:UIControlStateNormal];
        [_btn12 setBackgroundImage:[UIImage imageNamed:@"btn12v"] forState:UIControlStateNormal];
        
        for (int i = 0; i < 4; i++) {
            UIImageView *vipImage = [[UIImageView alloc] initWithFrame:CGRectMake((2 + 80*i) * scale, 50 * scale, 15 * scale, 15 * scale)];
            vipImage.tag = 401 + i;
            [vipImage setImage:[UIImage imageNamed:@"vip"]];
            [_bottomView addSubview:vipImage];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
