//
//  Helpers.m
//  Travel
//
//  Created by Eugene Vegner on 10.06.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

NSNumber* NumberFromObj(id obj) {
    if (!obj) {
        return nil;
    }
    NSString *string = [NSString stringWithFormat:@"%@",obj];
    if ([string isEqualToString:@"true"]) {
        return @1;
    } else if ([string isEqualToString:@"false"]) {
        return @0;
    } else {
        return [NSDecimalNumber decimalNumberWithString: string];
    }
}

@end
