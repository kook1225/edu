//
//  SchoolModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol SchoolModel <NSObject>

@end

@interface SchoolModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *QYID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *DWMC;
@property (strong,nonatomic) NSString<Optional> *DWDZ;
@property (strong,nonatomic) NSString<Optional> *SFFB;
@property (strong,nonatomic) NSString<Optional> *DWWZ;

@end
