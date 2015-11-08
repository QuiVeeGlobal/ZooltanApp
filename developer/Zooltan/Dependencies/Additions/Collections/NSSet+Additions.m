//
//  NSSet(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSSet+Additions.h"

@implementation NSSet (Additions)

- (id) anyObjectPassingTest: (BOOL (^)(id)) predicate
{
	return [self objectsPassingTest: ^BOOL(id obj, BOOL *stop) { return *stop = predicate(obj); }].anyObject;
}

- (BOOL) containsObjectPassingTest: (BOOL (^)(id obj)) predicate
{
    return [self anyObjectPassingTest: predicate] != nil;
}

- (BOOL) containsAllObjectsFrom: (id <NSFastEnumeration>) collection
{
    for (id obj in collection)
        if (![self containsObject: obj])
            return NO;
    return YES;
}

@end