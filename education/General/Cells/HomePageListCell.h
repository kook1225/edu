//
//  HomePageListCell.h
//  education
//
//  Created by zhujun on 15/6/30.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageListCell : UITableViewCell {
    CGSize labelSize;
    UIImage *singleImage;
    UIImageView *imageView;
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *evaluteBtn;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UITableView *tableView;

- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray reply:(NSArray *)replyArray index:(NSInteger)indexRow;

@end
