//
//  EDPhotoDetailCell.h
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDPhotoDetailHeadCell.h"
#import "EDPhotoDetailContentCell.h"

@interface EDPhotoDetailCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    CGSize labelSize;
    NSArray *dataArray;
}
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *msgBtn;

@property (nonatomic,strong) UITableView *tableView;



- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray comment:(NSArray *)commentArray;
@end
