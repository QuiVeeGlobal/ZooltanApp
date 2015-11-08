//
//  BaseModel.m
//  Experts
//
//  Created by Eugene Vegner on 09.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self != nil){
        [self mappingDictionary:dictionary];
	}
	return self;
}

- (void)mappingDictionary:(NSDictionary *)dictionary {
    STLogMethod;
}

- (BOOL)validated {return NO;}


@end
