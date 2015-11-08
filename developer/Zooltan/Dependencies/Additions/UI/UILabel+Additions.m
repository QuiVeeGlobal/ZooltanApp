//
//  UILabel(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (UIFont *)adjustedFont
{
//    CGFloat adjustedFontSize;
//    [self.text sizeWithFont: self.font
//                minFontSize: self.minimumFontSize
//             actualFontSize: &adjustedFontSize
//                   forWidth: self.bounds.size.width
//              lineBreakMode: self.lineBreakMode];
//    return [UIFont fontWithName: self.font.fontName size: adjustedFontSize];
    return nil;
}

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
    [text addAttribute: NSForegroundColorAttributeName
                 value: textColor
                 range: range];
    
    [self setAttributedText: text];
}

- (void)setFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
    [text addAttribute: NSFontAttributeName
                 value: font
                 range: range];
    
    [self setAttributedText: text];
}

@end