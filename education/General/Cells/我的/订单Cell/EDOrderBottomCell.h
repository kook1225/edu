//
//  EDOrderBottomCell.h
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDOrderBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setDataDic:(NSDictionary *)dic;
@end
