//
//  NSIndexPath+Additions.m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSIndexPath+Additions.h"

@implementation NSIndexPath(Additions)

- (NSIndexPath*) indexPathForPreviousRow { return [NSIndexPath indexPathForRow: self.row - 1 inSection: self.section]; }
- (NSIndexPath*) indexPathForNextRow     { return [NSIndexPath indexPathForRow: self.row + 1 inSection: self.section]; }

+ (NSArray*) indexPathsStartingWith: (int) start ending: (int) ending section: (int) section
{
    NSMutableArray* array = [NSMutableArray array];
    for (int i = start; i < ending; i++)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow: i inSection: section];
        [array addObject: indexPath];
    }
    return array;
}

@end
