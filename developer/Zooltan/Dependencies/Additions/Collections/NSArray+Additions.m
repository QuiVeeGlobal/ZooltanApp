//
//  NSArray+Additions.m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSArray+Additions.h"
#import "NSMutableArray+Additions.h"

@implementation NSArray(Additions)

- (NSDictionary*) splitIntoSections: (NSString* (^)(id obj)) titlePredicate titles: (NSArray**) titles
{
	NSMutableArray* sectionTitles = [NSMutableArray array];
	NSMutableDictionary* sections = [NSMutableDictionary dictionary];
	for (NSObject* entity in self)
	{
		NSString* firstLetter = [[titlePredicate(entity) substringToIndex: 1] uppercaseString];
		if (![sections.allKeys containsObject: firstLetter])
		{
			[sectionTitles addObject: firstLetter];
			[sections setObject: [NSMutableArray array] forKey: firstLetter];
		}
		[[sections objectForKey: firstLetter] addObject: entity];
	}

    //Sort section contents
    for (id section in sectionTitles)
    {
        NSMutableArray* sectionItems = [sections objectForKey: section];
        [sectionItems sortUsingComparator: ^(id first, id second)
                                           {
                                               NSString* firstTitle  = titlePredicate(first);
                                               NSString* secondTitle = titlePredicate(second);
                                               return [firstTitle caseInsensitiveCompare: secondTitle];
                                           }];
    }

    if (titles)
        *titles = [sectionTitles sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
	return sections;
}

- (NSRange) range { return NSMakeRange(0, self.count); }

- (id) firstObjectPassingTest: (BOOL (^)(id)) predicate
{
	NSUInteger index = [self indexOfObjectPassingTest: ^(id obj, NSUInteger idx, BOOL *stop)
				                                       {
                                                           *stop = predicate(obj);
				   	                                       return *stop;
				                                       }];
	return index == NSNotFound ? nil : [self objectAtIndex: index];
}

- (id) firstObjectOfClass: (Class) aClass
{
    return [self firstObjectPassingTest: ^(id obj){ return [obj isKindOfClass: aClass]; }];
}

- (BOOL) containsObjectPassingTest: (BOOL (^)(id obj)) predicate
{
    id object = [self firstObjectPassingTest: predicate];
    return object != nil;
}

- (NSArray*) objectsPassingTest: (BOOL (^)(id obj, NSUInteger idx, BOOL* stop)) predicate
{
	NSIndexSet* indexSet = [self indexesOfObjectsPassingTest: predicate];
    if (indexSet.count)
	    return [self objectsAtIndexes: indexSet];
    else
        return nil;
}

- (NSArray*) objectsOfClass: (Class) class
{
    return [self objectsPassingTest: ^BOOL(id obj, NSUInteger idx, BOOL* stop) { return [obj class] == class; }];
}

- (NSUInteger) indexOfObjectBefore: (id) object
{
    if (!object)
        return NSNotFound;

    NSUInteger index = [self indexOfObject: object];
    if (index == NSNotFound || index == 0)
        return NSNotFound;
    return index - 1;
}

- (id) objectBefore: (id) object
{
    NSUInteger index = [self indexOfObjectBefore: object];
    return index == NSNotFound ? nil : [self objectAtIndex: index];
}

- (id) objectAfter: (id) object
{
    NSUInteger index = [self indexOfObject: object];
    return [self objectAtIndex: index + 1];
}

- (NSArray*) arrayByReplacingObject: (id) object withObject: (id) otherObject
{
    NSMutableArray* result = [NSMutableArray arrayWithArray: self];
    [result replaceObject: object withObject: otherObject];
    return result;
}

- (NSArray*) arrayByPrependingObject: (id) object
{
    if (!object)
        return self;

    NSMutableArray* result = [NSMutableArray arrayWithCapacity: self.count + 1];
    [result addObject: object];
    [result addObjectsFromArray: self];
    return result;
}

- (NSArray*) arrayByReplacingObjectPassingTest: (BOOL (^)(id obj)) predicate withObject: (id) object
{
	for (NSUInteger i = 0; i != self.count; i++)
	{
		id objToReplace = [self objectAtIndex: i];
		if (predicate(objToReplace))
		{
			NSMutableArray* result = [NSMutableArray arrayWithArray: self];
			[result replaceObjectAtIndex: i withObject: object];
			return result;
		}
	}
	return self.copy;
}

- (NSArray*) arrayByRemovingFirstObjectPassingTest: (BOOL (^)(id obj)) predicate
{
	for (NSUInteger i = 0; i != self.count; i++)
	{
		id objToRemove = [self objectAtIndex: i];
		if (predicate(objToRemove))
		{
			NSMutableArray* result = [NSMutableArray arrayWithArray: self];
			[result removeObjectAtIndex: i];
			return result;
		}
	}
	return self.copy;
}

- (NSArray*) arrayByRemovingFirstObjectEqualTo: (id) object
{
    return [self arrayByRemovingFirstObjectPassingTest: ^(id obj) { return [object isEqual: obj]; }];
}

- (NSArray*) subarrayFromIndex: (NSUInteger) index
{
    NSRange range = NSMakeRange(index, self.count - index);
    return [self subarrayWithRange: range];
}

- (NSArray*) arrayByTransformingElementsWithBlock: (id (^)(id obj, NSUInteger index)) block;
{
    if (!block)
        [NSException raise: @"NilArgumentException" format: @"block is nil"];

    NSMutableArray* result = [NSMutableArray arrayWithCapacity: self.count];
    for (NSUInteger i = 0; i != self.count; i++)
    {
        id element = [self objectAtIndex: i];
        id transformedElement = block(element, i);
        [result addObject: transformedElement];
    }
    return result;
}

- (NSArray*) splitIntoSubArraysWithSize: (NSUInteger) size
{
    if (!self.count)
        return nil;

    NSMutableArray* result = [NSMutableArray arrayWithCapacity: self.count % size];
    for (NSUInteger i = 0; i < self.count; i += size)
    {
        NSRange range = NSMakeRange(i, size);
        if (range.location + range.length > self.count)
            range.length = self.count - range.location;

        NSArray* subArray = [self subarrayWithRange: range];
        [result addObject: subArray];
    }
    return result;
}

- (NSComparisonResult) compareIndexesOfObject: (id) obj andObject: (id) otherObj
{
    NSUInteger index      = [self indexOfObject: obj];
    NSUInteger otherIndex = [self indexOfObject: otherObj];
    if (index > otherIndex)
        return NSOrderedAscending;
    else if (index == otherIndex)
        return NSOrderedSame;
    return NSOrderedDescending;
}

- (NSArray*) shuffledArray
{
    NSMutableArray* shuffledArray = [self mutableCopy];
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        NSUInteger nElements = count - i;
        NSUInteger n = arc4random_uniform((int)nElements) + i;
        [shuffledArray exchangeObjectAtIndex: i withObjectAtIndex: n];
    }
    return shuffledArray;
}

@end
