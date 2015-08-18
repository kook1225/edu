//
//  EDHomeWorkTableViewCell.h
//  education
//
//  Created by Apple on 15/8/18.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDHomeWorkTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *contentLabel;
-(void)setIntroductionText:(NSString*)text height:(CGFloat)high;
@end
