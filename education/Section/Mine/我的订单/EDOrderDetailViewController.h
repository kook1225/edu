//
//  EDOrderDetailViewController.h
//  education
//
//  Created by Apple on 15/7/3.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDOrderDetailViewControllerDelegate <NSObject>

- (void)setTableViewReload:(NSString *)typeStr;

@end

@interface EDOrderDetailViewController : UIViewController

@property (nonatomic,strong) id<EDOrderDetailViewControllerDelegate> delegate;

@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong)NSString *type;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//状态View
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;

//订单时间View
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
//收货View
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userAddress;
@property (weak, nonatomic) IBOutlet UIImageView *addressImg;
@property (weak, nonatomic) IBOutlet UILabel *nonAddress;


//cell内容
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsOriPrice;

@property (weak, nonatomic) IBOutlet UILabel *goodsNum;

//留言View
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

//bottomView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


@end
