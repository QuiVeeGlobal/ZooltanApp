//
//  Fonts.m
//  RunCoachM
//
//  Created by Eugene Vegner on 14.10.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "Fonts.h"

@implementation Fonts

+ (UIFont *)setOpenSansWithFontSize:(CGFloat)size
{
    return [self fontWithName:@"OpenSans" size:size];
}

+ (UIFont *)setOpenSansBoldWithFontSize:(CGFloat)size
{
    return [self fontWithName:@"OpenSans-Bold" size:size];
}


@end
