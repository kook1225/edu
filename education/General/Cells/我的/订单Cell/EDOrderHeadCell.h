//
//  EDOrderHeadCell.h
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDOrderHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

- (void)setDataDic:(NSDictionary *)dic;
@end
