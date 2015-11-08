//
//  UILabel+AtrributedText.m
//  Travel
//
//  Created by Zabolotnyy S. on 18.06.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "UILabel+AtrributedText.h"

@implementation UILabel (AtrributedText)

- (void)setField:(NSString*)field inString:(NSMutableString*)string withValue:(NSString*)value
{
    if (!value.length) {
        value = @"";
    }
    [string replaceOccurrencesOfString:field withString:value options:0 range:NSMakeRange(0, [string length])];
}

- (void)setText:(NSString *)text forTemplate:(NSString*)templatetext
{
    NSMutableAttributedString* attributedString = [NSMutableAttributedString new];
    [attributedString setAttributedString:[self attributedText]];
    NSMutableString* string = attributedString.mutableString;
    
    [self setField:templatetext inString:string withValue:text];
    [self setAttributedText:attributedString];
}

@end
