//
//  AuthorModel.h
//  education
//
//  Created by zhujun on 15/7/17.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol AuthorModel <NSObject>

@end

@interface AuthorModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *YHM;
@property (strong,nonatomic) NSString<Optional> *YHLB;
@property (strong,nonatomic) NSString<Optional> *YHTX;
@property (strong,nonatomic) NSString<Optional> *XM;

@end
