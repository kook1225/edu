//
//  EDMyOrderCell.m
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "EDMyOrderCell.h"
#import <UIImageView+WebCache.h>

@implementation EDMyOrderCell

- (void)awakeFromNib {
    // Initialization code
    _headImg.layer.cornerRadius = 4.0f;
    _headImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dic
{
    _titleLabel.text = dic[@"productinfo"][@"name"];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"productinfo"][@"sale_price"]];
    _oriPriceLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"productinfo"][@"market_price"]];
    NSString *imgString = [NSString stringWithFormat:@"%@%@",IMG_HOST,dic[@"productinfo"][@"samll_img"]];
    NSURL *url = [NSURL URLWithString:imgString];
    [_headImg  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_default"]];
    _countLabel.text = [NSString stringWithFormat:@"数量:*%@",dic[@"orderinfo"][@"num"]];
    
    _countLabel.text = [NSString stringWithFormat:@"共%@件商品,实付:",dic[@"orderinfo"][@"num"]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"orderinfo"][@"amount"]];
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",dic[@"orderinfo"][@"order_num"]];
    
    _orderStatusLabel.text = dic[@"orderinfo"][@"status"];
    
}
@end
