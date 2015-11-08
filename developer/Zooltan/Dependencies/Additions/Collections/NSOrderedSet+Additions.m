//
//  NSOrderedSet(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSOrderedSet+Additions.h"

@implementation NSOrderedSet (Additions)

- (id) firstObjectPassingTest: (BOOL (^)(id)) predicate
{
    NSUInteger index = [self indexOfObjectPassingTest: ^(id obj, NSUInteger idx, BOOL *stop)
   				                                       {
                                                              *stop = predicate(obj);
   				   	                                       return *stop;
   				                                       }];
   	return index == NSNotFound ? nil : [self objectAtIndex: index];
}

- (id) objectAfter: (id) object
{
    NSUInteger index = [self indexOfObject: object];
    return [self objectAtIndex: index + 1];
}

@end