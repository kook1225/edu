//
//  MUScoreModel.h
//  education
//
//  Created by Apple on 15/7/20.
//  Copyright (c) 2015年 zhujun. All rights reserved.
//

#import "JSONModel.h"
#import "MUScoreListModel.h"

@interface MUScoreModel : JSONModel
@property (nonatomic,strong) NSString *KSMC;
@property (nonatomic,strong) NSString *KSSJ;
@property (nonatomic,strong) NSArray<Optional> *list;
@end
