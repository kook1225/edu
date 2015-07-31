//
//  EDOrderBottomCell.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDOrderBottomCell.h"

@implementation EDOrderBottomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dic
{
    _countLabel.text = [NSString stringWithFormat:@"共%@件商品,实付:",dic[@"num"]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"amount"]];
}
@end
