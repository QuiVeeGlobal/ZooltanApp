//
//  ResponseModel.h
//  Experts
//
//  Created by Eugene Vegner on 17.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import "BaseModel.h"

@interface ResponseModel : BaseModel
@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSString *status;
@property (nonatomic, assign) NSInteger code;

- (id)initWithResponseData:(id)responseData;

@end
