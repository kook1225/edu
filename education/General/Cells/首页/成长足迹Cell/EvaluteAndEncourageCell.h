//
//  EvaluteAndEncourageCell.h
//  education
//
//  Created by zhujun on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "growUpModel.h"

@interface EvaluteAndEncourageCell : UITableViewCell {
    CGSize labelSize;
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setIntroductionText:(NSString*)text name:(NSString *)name;
- (void)setData:(growUpModel *)model;

@end
