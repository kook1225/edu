//
//  EDInfoArrayModel.h
//  education
//
//  Created by Apple on 15/7/15.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface EDInfoArrayModel : JSONModel
@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *ZYMC;
@property (strong,nonatomic) NSString<Optional> *QYMC;
@end
