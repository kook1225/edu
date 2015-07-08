//
//  EDMyPhotoCell.h
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDMyPhotoCell : UITableViewCell
{
    CGSize labelSize;
}
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *zanBtn;
@property (nonatomic,strong) UIButton *msgBtn;
@property (nonatomic,strong) UIView *lineView;

- (void)setIntroductionText:(NSString*)text image:(NSArray *)imagesArray;
@end
