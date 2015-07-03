//
//  ClassCircleCell.h
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCircleCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate> {
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
@property (nonatomic,strong) UIView *btnView;
@property (nonatomic,strong) UIView *btnView2;
@property (nonatomic,strong) UIImageView *praiseImageView;
@property (nonatomic,strong) UIImageView *evaluteImageView;
@property (nonatomic,strong) UILabel *praiseLabel;
@property (nonatomic,strong) UILabel *evaluteLabel;
@property (nonatomic,strong) UITableView *tableView;

- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray reply:(NSArray *)replyArray index:(NSInteger)indexRow;

@end
