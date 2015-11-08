//
//  NSMutableArray(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Additions)

- (NSInteger) insertObject: (id) object beforeObject: (id) otherObject;
- (NSInteger) replaceObject: (id) object withObject: (id) otherObject;
- (NSInteger) removeObjectsEqualTo: (id) obj;
- (NSInteger) replaceObjectPassingTest: (BOOL (^)(id obj)) predicate withObject: (id) otherObject;
- (NSInteger) removeObjectsPassingTest: (BOOL (^)(id obj)) predicate;
- (NSInteger) addAllObjects: (NSArray*) array passingTest: (BOOL (^)(id)) predicate;

- (void) removeDuplicates;

- (void) moveFirstObjectToBack;
- (void) moveLastToFront;

@end
