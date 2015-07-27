//
//  JournalCell.m
//  education
//
//  Created by zhujun on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JournalCell.h"

@implementation JournalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(growUpModel *)model {
    _mainView.layer.borderColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000].CGColor;
    _mainView.layer.borderWidth = 1;
    
    
    if ([model.FBRLX intValue] == 3) {
        _nameLabel.text = [NSString stringWithFormat:@"from %@",model.FBRXM];;
        [_nameLabel sizeToFit];
        
        _replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 10, _nameLabel.frame.origin.y - 2, 40, 20)];
        [_replyBtn setTitle:[NSString stringWithFormat:@"回复%@",model.HFS] forState:UIControlStateNormal];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _replyBtn.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.000];
        
        _replyBtn.layer.borderColor = [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1.000].CGColor;
        _replyBtn.layer.borderWidth = 1;
        _replyBtn.layer.cornerRadius = 5.0f;
        
        [_replyBtn setTitleColor:[UIColor colorWithRed:255.0/255.0f green:124.0/255.0f blue:6.0/255.0f alpha:1.000f] forState:UIControlStateNormal];
        [_mainView addSubview:_replyBtn];
        
        _dateLabel.text = model.FBSJ;
        _contentLabel.text = model.FBNR;
    }
    else {
        _nameLabel.text = model.XXBT;
        
        _dateLabel.text = model.FBSJ;
        _contentLabel.text = model.FBNR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
