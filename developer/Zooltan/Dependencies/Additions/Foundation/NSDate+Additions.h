//
//  NSDate+Additions.h
//  Dependencies
//
//  Created by Eugene Vegner on 10.04.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSString *)stringWithFormat:(NSString *)format;

- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;
- (NSDate *)addDays:(NSInteger)days;


@end
