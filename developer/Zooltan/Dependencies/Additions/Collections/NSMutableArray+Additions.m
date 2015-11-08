//
//  NSMutableArray(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSMutableArray+Additions.h"
#import "NSArray+Additions.h"

@implementation NSMutableArray(Additions)

- (NSInteger) insertObject: (id) object beforeObject: (id) otherObject
{
    NSUInteger index = [self indexOfObject: otherObject];
    if (index == NSNotFound)
        return NSNotFound;

    [self insertObject: object atIndex: index];
    return index;
}

- (NSInteger) replaceObject: (id) object withObject: (id) otherObject
{
	NSUInteger index = [self indexOfObject: object];
	if (index == NSNotFound)
		return NSNotFound;

	[self replaceObjectAtIndex: index withObject: otherObject];
	return index;
}

- (NSInteger) addAllObjects: (NSArray*) array passingTest: (BOOL (^)(id)) predicate
{
    NSInteger counter = 0;
    for (id obj in array)
    {
        if (predicate(obj))
        {
            [self addObject: obj];
            counter++;
        }
    }
    return counter;
}

- (void) removeDuplicates
{
    for (NSUInteger i = 0; i != self.count; i++)
    {
        NSObject* object = [self objectAtIndex: i];
        [self removeObjectsPassingTest: (BOOL (^)(id)) ^(id obj)
                {
                    NSObject* otherObject = obj;
                    return (otherObject != object) && [otherObject isEqual: object];
                }];
    }
}

- (void) moveFirstObjectToBack
{
	NSObject* firstObject = self.firstObject;
	if (!firstObject)
		return;

	[self removeObjectAtIndex: 0];
	[self addObject: firstObject];
}

- (void) moveLastToFront
{
	NSObject* lastObject = self.lastObject;
	if (!lastObject)
		return;

	[self removeLastObject];
	[self insertObject: lastObject atIndex: 0];
}

- (NSInteger) removeObjectsPassingTest: (BOOL (^)(id obj)) predicate
{
    NSInteger objectsRemoved = 0;
    for (NSUInteger i = 0; i != self.count; i++)
    {
        BOOL remove = predicate([self objectAtIndex: i]);
        if (remove)
        {
            [self removeObjectAtIndex: i];
            objectsRemoved++;
            i--;
        }
    }
    return objectsRemoved;
}

- (NSInteger) removeObjectsEqualTo: (id) obj
{
    return [self removeObjectsPassingTest: ^(id otherObj) { return [otherObj isEqual: obj]; }];
}

- (NSInteger) replaceObjectPassingTest: (BOOL (^)(id)) predicate withObject: (id) otherObject
{
    NSUInteger index = [self indexOfObjectPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL *stop)
                                                       {
                                                           return *stop = predicate(obj);
                                                       }];
    if (index != NSNotFound)
        [self replaceObjectAtIndex: index withObject: otherObject];
    return index;
}

@end
