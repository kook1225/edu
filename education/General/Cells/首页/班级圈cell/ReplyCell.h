//
//  ReplyCell.h
//  neighborhood
//
//  Created by zhu jun on 15/5/13.
//  Copyright (c) 2015年 sportsexp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyCell : UITableViewCell {
    CGSize labelSize;
}
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIView *borderView;

- (void)setIntroductionText:(NSString*)text name:(NSString *)name labelWidth:(float)width;

@end
