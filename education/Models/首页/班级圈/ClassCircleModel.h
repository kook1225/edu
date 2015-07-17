//
//  ClassCircleModel.h
//  education
//
//  Created by zhujun on 15/7/17.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "ListModel.h"

@interface ClassCircleModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *totalCount;
@property (strong,nonatomic) NSString<Optional> *totalPage;
@property (strong,nonatomic) NSString<Optional> *pageSize;
@property (strong,nonatomic) NSString<Optional> *page;
@property (strong,nonatomic) NSArray<ListModel,Optional> *list;

@end
