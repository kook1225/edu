//
//  SureOrderViewController.m
//  education
//
//  Created by zhujun on 15/7/6.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "SureOrderViewController.h"
#import "SelectAddViewController.h"

@interface SureOrderViewController () {
    int num;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end

@implementation SureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    num = 1;
    
    _addLabel.text = @"份水电费水电费水电费水电费水电费水电费水电费大大叔水电费水电费水电费大大水电费水电费水电费大大";
    _addLabel.numberOfLines = 2;
    [_addLabel sizeToFit];
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(112, 35, 10, 20)];
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.text = @"¥";
    [_introView addSubview:label];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 33, 30, 20)];
    _priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:42.0/255.0 blue:45/255.0 alpha:1.000];
    _priceLabel.font = [UIFont boldSystemFontOfSize:18];
    _priceLabel.text = @"200";
    [_priceLabel sizeToFit];
    [_introView addSubview:_priceLabel];
    
    
    _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 5, 35, 30, 20)];
    
    _oldPriceLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
    _oldPriceLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *oldPrice = @"¥280";
    NSUInteger length=[oldPrice length];
    
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc]initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)range:NSMakeRange(0,length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000]
                  range:NSMakeRange(2, length-2)];
    
    //[_oldPriceLabel sizeToFit];
    [_oldPriceLabel setAttributedText:attri];
    [_introView addSubview:_oldPriceLabel];
    
    
    _totalPrice.text = _priceLabel.text;
    
    self.navigationItem.leftBarButtonItem = [Tools getNavBarItem:self clickAction:@selector(back)];
}

#pragma mark - Custom Method
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reduceBtn:(id)sender {
    if ([_numLabel.text intValue] > 1) {
        num--;
        _numLabel.text = [NSString stringWithFormat:@"%d",num];
        _goodsNumLabel.text = [NSString stringWithFormat:@"x %d",num];
        _totalPrice.text = [NSString stringWithFormat:@"%d",[_priceLabel.text intValue] * num];
    }
}
- (IBAction)addBtn:(id)sender {
    if ([_numLabel.text intValue] < 99) {
        num++;
        _numLabel.text = [NSString stringWithFormat:@"%d",num];
        _goodsNumLabel.text = [NSString stringWithFormat:@"x %d",num];
        _totalPrice.text = [NSString stringWithFormat:@"%d",[_priceLabel.text intValue] * num];
    }
}

- (IBAction)addTap:(id)sender {
    SelectAddViewController *selectAddVC = [[SelectAddViewController alloc] init];
    [self.navigationController pushViewController:selectAddVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
