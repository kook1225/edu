//
//  HomePageListCell.h
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

@interface HomePageListCell : UITableViewCell {
    CGSize labelSize;
    UIImage *singleImage;
    UIImageView *imageView;
    NSArray *dataArray;
    NSArray *imageArray;
    NSInteger row;
}

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *evaluteBtn;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIView *btnView;
@property (nonatomic,strong) UIView *btnView2;
@property (nonatomic,strong) UIImageView *praiseImageView;
@property (nonatomic,strong) UIImageView *evaluteImageView;
@property (nonatomic,strong) UILabel *praiseLabel;
@property (nonatomic,strong) UILabel *evaluteLabel;
@property (nonatomic,strong) UIButton *priBtn;
@property (nonatomic,strong) UIButton *rlyBtn;

- (void)setData:(ListModel *)model;
- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray reply:(ListModel *)model index:(NSInteger)indexRow;

@end
