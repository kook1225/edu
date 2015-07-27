//
//  EDPhotoDetailViewController.h
//  education
//
//  Created by Apple on 15/7/8.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

@interface EDPhotoDetailViewController : UIViewController

@property (nonatomic,strong) ListModel *model;
@property (nonatomic,strong) NSString *index;
@property (nonatomic,strong) NSString *album;

@end
