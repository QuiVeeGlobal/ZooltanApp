//
//  NSDate+Additions.m
//  Dependencies
//
//  Created by Eugene Vegner on 10.04.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    //[formatter setTimeZone:[NSTimeZone systemTimeZone]];
    //[formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSDate *)addDays:(NSInteger)days {
   return [self dateByAddingTimeInterval:60*60*24*days];
}

#pragma mark Helpers

- (NSDate *)toLocalTime  {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSDate *)toGlobalTime  {
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}


@end
