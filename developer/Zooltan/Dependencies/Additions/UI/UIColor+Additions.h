//
//  UIColor(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor*) colorWithHex: (uint) hex;
+ (UIColor*) colorWithHexString: (NSString *) str;
+ (UIColor*) colorFromRGBIntegers: (int) red green: (int) green blue: (int) blue alpha: (CGFloat) alpha;

@end