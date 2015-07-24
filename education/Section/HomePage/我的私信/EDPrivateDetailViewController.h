//
//  EDPrivateDetailViewController.h
//  education
//
//  Created by Apple on 15/7/9.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "growUpModel.h"

@interface EDPrivateDetailViewController : UIViewController
{
    CGSize labelSize;
}

@property (nonatomic,strong) growUpModel *model;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *imagesString;
@end
