//
//  NSOrderedSet(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOrderedSet (Additions)

- (id) firstObjectPassingTest: (BOOL (^)(id)) predicate;

- (id) objectAfter: (id) object;

@end