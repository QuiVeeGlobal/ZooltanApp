//
//  BaseModel.h
//  Experts
//
//  Created by Eugene Vegner on 09.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)mappingDictionary:(NSDictionary *)dictionary;

- (BOOL)validated;

@end
