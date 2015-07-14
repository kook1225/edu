//
//  SchoolModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface SchoolModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *_id;
@property (strong,nonatomic) NSString<Optional> *_qyid;
@property (strong,nonatomic) NSString<Optional> *_dwid;
@property (strong,nonatomic) NSString<Optional> *_dwmc;
@property (strong,nonatomic) NSString<Optional> *_dwdz;
@property (strong,nonatomic) NSString<Optional> *_sffb;
@property (strong,nonatomic) NSString<Optional> *_dwwz;

@end
