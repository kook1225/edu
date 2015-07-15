//
//  TokenInforModel.h
//  education
//
//  Created by zhujun on 15/7/14.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol TokenInforModel <NSObject>

@end

@interface TokenInforModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *access_token;
@property (strong,nonatomic) NSString<Optional> *scope;
@property (strong,nonatomic) NSString<Optional> *expires_in;

@end
