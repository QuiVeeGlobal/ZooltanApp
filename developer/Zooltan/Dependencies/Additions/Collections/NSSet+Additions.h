//
//  NSSet(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Additions)

- (id) anyObjectPassingTest: (BOOL (^)(id)) predicate;
- (BOOL) containsObjectPassingTest: (BOOL (^)(id obj)) predicate;
- (BOOL) containsAllObjectsFrom: (id <NSFastEnumeration>) collection;

@end