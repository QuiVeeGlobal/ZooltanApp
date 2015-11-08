//
//  NSArray+Additions.h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Additions)
    @property (nonatomic, readonly) NSRange range;

- (id)   firstObjectPassingTest: (BOOL (^)(id)) predicate;
- (id)   firstObjectOfClass: (Class) aClass;
- (BOOL) containsObjectPassingTest: (BOOL (^)(id obj)) predicate;
- (NSArray*) objectsPassingTest: (BOOL (^)(id obj, NSUInteger idx, BOOL* stop)) predicate;
- (NSArray*) objectsOfClass: (Class) class;
- (NSUInteger) indexOfObjectBefore: (id) object;
- (id) objectBefore: (id) object;
- (id) objectAfter: (id) object;

- (NSDictionary*) splitIntoSections: (NSString* (^)(id obj)) titlePredicate titles: (NSArray**) titles;

- (NSArray*) arrayByPrependingObject: (id) object;

- (NSArray*) arrayByReplacingObject: (id) object withObject: (id) otherObject;
- (NSArray*) arrayByReplacingObjectPassingTest: (BOOL (^)(id obj)) predicate withObject: (id) object;

- (NSArray*) arrayByRemovingFirstObjectPassingTest:  (BOOL (^)(id obj)) predicate;
- (NSArray*) arrayByRemovingFirstObjectEqualTo: (id) object;

- (NSArray*) subarrayFromIndex: (NSUInteger) index;

- (NSArray*) arrayByTransformingElementsWithBlock: (id (^)(id obj, NSUInteger index)) block;

- (NSArray*) splitIntoSubArraysWithSize: (NSUInteger) size;

- (NSComparisonResult) compareIndexesOfObject: (id) obj andObject: (id) otherObj;

- (NSArray*) shuffledArray;
@end
