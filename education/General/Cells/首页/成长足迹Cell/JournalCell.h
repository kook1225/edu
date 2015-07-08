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

- (void)setData;

@end
