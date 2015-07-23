//
//  SelectAddCell.h
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipAddListModel.h"

@interface SelectAddCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;


- (void)setData;

- (void)setData:(ShipAddListModel *)model;

@end
