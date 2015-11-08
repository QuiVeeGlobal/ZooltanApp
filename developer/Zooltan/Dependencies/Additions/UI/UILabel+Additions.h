//
//  UILabel(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Additions)

- (UIFont *)adjustedFont;
- (void)setTextColor:(UIColor *)textColor range:(NSRange)range;
- (void)setFont:(UIFont *)font range:(NSRange)range;



@end