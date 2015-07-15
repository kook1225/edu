//
//  ClassModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol ClassModel <NSObject>

@end

@interface ClassModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *NJID;
@property (strong,nonatomic) NSString<Optional> *BJID;
@property (strong,nonatomic) NSString<Optional> *BJMC;
@property (strong,nonatomic) NSString<Optional> *BZR;
@property (strong,nonatomic) NSString<Optional> *XH;

@end
