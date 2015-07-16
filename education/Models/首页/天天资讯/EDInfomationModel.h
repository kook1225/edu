//
//  EDInfomationModel.h
//  education
//
//  Created by Apple on 15/7/15.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "EDInfoArrayModel.h"

@interface EDInfomationModel : JSONModel
@property (strong,nonatomic) NSArray<Optional> *list;

@end
