//
//  EDOrderHeadCell.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDOrderHeadCell.h"

@implementation EDOrderHeadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dic
{
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",dic[@"order_num"]];
    _orderStatusLabel.text = dic[@"status"];
}
@end
