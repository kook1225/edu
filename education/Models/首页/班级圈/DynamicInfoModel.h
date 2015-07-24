//
//  DynamicInfoModel.h
//  education
//
//  Created by zhujun on 15/7/17.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol DynamicInfoModel <NSObject>

@end

@interface DynamicInfoModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *NJID;
@property (strong,nonatomic) NSString<Optional> *BJID;
@property (strong,nonatomic) NSString<Optional> *TPLY;
@property (strong,nonatomic) NSString<Optional> *FMLY;
@property (strong,nonatomic) NSString<Optional> *TPSM;
@property (strong,nonatomic) NSString<Optional> *TJRY;
@property (strong,nonatomic) NSString<Optional> *TJSJ;
@property (strong,nonatomic) NSString<Optional> *FBFW;
@property (strong,nonatomic) NSString<Optional> *FBID;
@property (strong,nonatomic) NSString<Optional> *SFFB;
@property (strong,nonatomic) NSString<Optional> *SLT;

@end
