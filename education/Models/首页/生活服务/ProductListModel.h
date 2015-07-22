//
//  ProductListModel.h
//  education
//
//  Created by zhujun on 15/7/22.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"

@interface ProductListModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *typename;
@property (nonatomic,strong) NSString<Optional> *img;
@property (nonatomic,strong) NSString<Optional> *id;
@property (nonatomic,strong) NSString<Optional> *name;
@property (nonatomic,strong) NSString<Optional> *product_type_id;
@property (nonatomic,strong) NSString<Optional> *market_price;
@property (nonatomic,strong) NSString<Optional> *sale_price;
@property (nonatomic,strong) NSString<Optional> *unit;
@property (nonatomic,strong) NSString<Optional> *intro;
@property (nonatomic,strong) NSString<Optional> *status;
@property (nonatomic,strong) NSString<Optional> *seq;
@property (nonatomic,strong) NSString<Optional> *samll_img;
@property (nonatomic,strong) NSString<Optional> *salecount;

@end
