//
//  EDClassOnlineCell.m
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDClassOnlineCell.h"
#import <UIImageView+WebCache.h>

@implementation EDClassOnlineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dic
{
    _titleLabel.text = dic[@"KEMU"];
    _playCountLabel.text = [NSString stringWithFormat:@"已播放 %@次",dic[@"CECI"]];
    
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,dic[@"ZYTP"]];
    NSURL *url = [NSURL URLWithString:imgString];
    [_bkgImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"] ];
}
@end
