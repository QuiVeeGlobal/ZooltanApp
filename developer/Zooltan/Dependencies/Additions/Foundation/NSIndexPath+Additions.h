//
//  NSIndexPath+Additions.h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSIndexPath (Additions)
    - (NSIndexPath*) indexPathForPreviousRow;
    - (NSIndexPath*) indexPathForNextRow;

    + (NSArray*) indexPathsStartingWith: (int) start ending: (int) ending section: (int) section;
@end
