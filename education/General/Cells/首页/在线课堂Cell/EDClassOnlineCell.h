//
//  EDClassOnlineCell.h
//  education
//
//  Created by Apple on 15/7/10.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDClassOnlineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bkgImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

- (void)setDataDic:(NSDictionary *)dic;
@end
