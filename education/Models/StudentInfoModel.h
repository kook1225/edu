//
//  StudentInfoModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol StudentInfoModel <NSObject>

@end

@interface StudentInfoModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *NJID;
@property (strong,nonatomic) NSString<Optional> *BJID;
@property (strong,nonatomic) NSString<Optional> *XSID;
@property (strong,nonatomic) NSString<Optional> *XSXM;
@property (strong,nonatomic) NSString<Optional> *FQXM;
@property (strong,nonatomic) NSString<Optional> *FQDH;
@property (strong,nonatomic) NSString<Optional> *FDLMM;
@property (strong,nonatomic) NSString<Optional> *MQXM;
@property (strong,nonatomic) NSString<Optional> *MQDH;
@property (strong,nonatomic) NSString<Optional> *MDLMM;
@property (strong,nonatomic) NSString<Optional> *XJID;
@property (strong,nonatomic) NSString<Optional> *YHTX;
@property (strong,nonatomic) NSString<Optional> *XSXB;
@property (strong,nonatomic) NSString<Optional> *NJMC;
@property (strong,nonatomic) NSString<Optional> *BJMC;
@property (strong,nonatomic) NSString<Optional> *QYMC;
@property (strong,nonatomic) NSString<Optional> *DWMC;

@end
