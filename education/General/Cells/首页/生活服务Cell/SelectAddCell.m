//
//  SelectAddCell.m
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SelectAddCell.h"

@implementation SelectAddCell

- (void)prepareForReuse {
    self.contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.000];
    [self.checkImageView setImage:[UIImage imageNamed:@""]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.checkImageView setImage:[UIImage imageNamed:@"check"]];
}

- (void)setData:(ShipAddListModel *)model {
    _nameLabel.text = model.contact;
    _mobileLabel.text = model.tel;
    if ([model.is_default intValue] == 1) {
        _addLabel.text = [NSString stringWithFormat:@"[默认]%@%@%@%@",model.province,model.city,model.district,model.address];
    }
    else {
        _addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
