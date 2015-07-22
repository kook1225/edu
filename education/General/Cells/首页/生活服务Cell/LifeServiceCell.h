//
//  lifeServiceCell.h
//  education
//
//  Created by zhujun on 15/7/4.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListModel.h"

@interface LifeServiceCell : UICollectionViewCell {
    CGFloat scale;
}

@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *saledLabel;

- (void)setData:(ProductListModel *)model;

@end
