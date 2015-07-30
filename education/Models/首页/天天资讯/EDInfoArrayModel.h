//
//  EDInfoArrayModel.h
//  education
//
//  Created by Apple on 15/7/15.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@protocol EDInfoArrayModel <NSObject>



@end

@interface EDInfoArrayModel : JSONModel
@property (strong,nonatomic) NSString<Optional> *ID;
@property (strong,nonatomic) NSString<Optional> *ZYMC;
@property (strong,nonatomic) NSString<Optional> *ZYNR;
@property (strong,nonatomic) NSString<Optional> *ZYTP;
@property (strong,nonatomic) NSString<Optional> *FBSJ;
@end
