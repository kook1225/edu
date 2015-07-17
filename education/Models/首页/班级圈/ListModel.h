//
//  ListModel.h
//  education
//
//  Created by zhujun on 15/7/17.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "DynamicInfoModel.h"
#import "AuthorModel.h"
#import "ReplysModel.h"

@protocol ListModel <NSObject>

@end

@interface ListModel : JSONModel

@property (strong,nonatomic) DynamicInfoModel<Optional> *dynamicInfo;
@property (strong,nonatomic) AuthorModel<Optional> *author;
@property (strong,nonatomic) NSArray<AuthorModel,Optional> *likes;
@property (strong,nonatomic) NSArray<ReplysModel,Optional> *replys;

@end
