//
//  EDMyOrderViewController.h
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface EDMyOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UIButton *no_payBtn;
@property (weak, nonatomic) IBOutlet UIButton *no_recieveBtn;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIButton *no_deliverBtn;

@end
