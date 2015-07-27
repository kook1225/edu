//
//  UserInfoModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol UserInfoModel <NSObject>


@end

@interface UserInfoModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *YHM;
@property (strong,nonatomic) NSString<Optional> *YHMM;
@property (strong,nonatomic) NSString<Optional> *YHLB;
@property (strong,nonatomic) NSString<Optional> *GLJB;
@property (strong,nonatomic) NSString<Optional> *GLID;
@property (strong,nonatomic) NSString<Optional> *GLXX;
@property (strong,nonatomic) NSString<Optional> *GLQY;
@property (strong,nonatomic) NSString<Optional> *YHTX;
@property (strong,nonatomic) NSString<Optional> *IsVip;

@end
