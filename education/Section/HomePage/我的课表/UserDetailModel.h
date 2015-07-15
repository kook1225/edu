//
//  UserDetailModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "SchoolModel.h"
#import "ClassModel.h"
#import "UserInfoModel.h"
#import "StudentInfoModel.h"
#import "TeacherInfoModel.h"

@interface UserDetailModel : JSONModel

@property (strong,nonatomic) UserInfoModel<Optional> *userinfo;
@property (strong,nonatomic) SchoolModel<Optional> *schoolInfo;
@property (strong,nonatomic) NSArray<ClassModel,Optional> *classInfo;
@property (strong,nonatomic) StudentInfoModel<Optional> *studentInfo;
@property (strong,nonatomic) TeacherInfoModel<Optional> *teacherInfo;

@end
