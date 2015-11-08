//
//  UIBarButtonItem+Additions.m
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"

@implementation UIBarButtonItem (Additions)

+ (id) barItemWithSystemItem: (UIBarButtonSystemItem) systemItem target: (id) target action: (SEL) action
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem: systemItem target: target action: action];
}

+ (id) itemWithTitle: (NSString*) title style: (UIBarButtonItemStyle) style target: (id) target action: (SEL) action
{
   	return [[UIBarButtonItem alloc] initWithTitle: title style: style target: target action: action];
}

+ (id) itemWithCustomView: (UIView*) view
{
    return [[UIBarButtonItem alloc] initWithCustomView: view];
}


@end
