//
//  TeacherInfoModel.h
//  education
//
//  Created by zhujun on 15/7/15.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol TeacherInfoModel <NSObject>

@end

@interface TeacherInfoModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *YHTH;
@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *DWID;
@property (strong,nonatomic) NSString<Optional> *JSXM;
@property (strong,nonatomic) NSString<Optional> *JSXB;
@property (strong,nonatomic) NSString<Optional> *RJXK;
@property (strong,nonatomic) NSString<Optional> *RJBJ;
@property (strong,nonatomic) NSString<Optional> *SRZW;
@property (strong,nonatomic) NSString<Optional> *DHHM;

@end
