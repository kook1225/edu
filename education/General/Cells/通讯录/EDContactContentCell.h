//
//  EDContactContentCell.h
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDContactContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImg;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
