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
#import "ListModel.h"

@interface EDPhotoDetailCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    CGSize labelSize;
    NSMutableArray *dataArray;
    ListModel *lisModel;
    NSSet *set;
    NSString *setTitle;
}
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *msgBtn;

@property (nonatomic,strong) UITableView *tableView;

- (void)setData:(ListModel *)model;

- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray comment:(ListModel *)listModel indexPath:(NSInteger)row;
@end
