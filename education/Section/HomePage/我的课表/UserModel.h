//
//  UserModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "TokenInforModel.h"
#import "UserDetailModel.h"

@interface UserModel : JSONModel

@property (strong,nonatomic) TokenInforModel<Optional> *TokenInfo;
@property (strong,nonatomic) UserDetailModel<Optional> *UserDetail;

@end
