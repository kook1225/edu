//
//  JournalCell.h
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) UIButton *replyBtn;

- (void)setData:(int)flag;

@end
