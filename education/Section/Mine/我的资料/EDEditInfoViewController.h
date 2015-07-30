//
//  EDEditInfoViewController.h
//  education
//
//  Created by Apple on 15/7/2.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDEditInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *school;
@property (weak, nonatomic) IBOutlet UITextField *grade;
@property (weak, nonatomic) IBOutlet UITextField *college;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *sex;

@property (weak, nonatomic) IBOutlet UILabel *birthDay;
@property (weak, nonatomic) IBOutlet UITextField *momName;
@property (weak, nonatomic) IBOutlet UITextField *momPhone;
@property (weak, nonatomic) IBOutlet UITextField *dadName;
@property (weak, nonatomic) IBOutlet UITextField *dadPhone;

@property (nonatomic,strong) NSString *imgAdd;

@end
