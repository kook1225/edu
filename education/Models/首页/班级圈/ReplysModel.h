//
//  ReplysModel.h
//  education
//
//  Created by zhujun on 15/7/17.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "AuthorModel.h"

@protocol ReplysModel <NSObject>

@end

@interface ReplysModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *XXID;
@property (strong,nonatomic) NSString<Optional> *NR;
@property (strong,nonatomic) NSString<Optional> *SJ;
@property (strong,nonatomic) AuthorModel<Optional> *author;

@end
