//
//  TopCell.h
//  education
//
//  Created by zhujun on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setTitle:(NSString *)name;

@end
