//
//  UIColor(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor*) colorWithHex: (uint) hex
{
	int red, green, blue, alpha;
	blue  =   hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red   = ((hex & 0x00FF0000) >> 16);
	alpha = ((hex & 0xFF000000) >> 24);
    return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: alpha / 255.0f];
}

+ (UIColor*) colorWithHexString: (NSString *) str
{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    UIColor *color = UIColorFromRGB(x);
    return color;
}

+ (UIColor*) colorFromRGBIntegers: (int) red green: (int) green blue: (int) blue alpha: (CGFloat) alpha
{
    CGFloat redF   = red   / 255.0f;
    CGFloat greenF = green / 255.0f;
    CGFloat blueF  = blue  / 255.0f;
    return [UIColor colorWithRed: redF green: greenF blue: blueF alpha: alpha];
}

@end