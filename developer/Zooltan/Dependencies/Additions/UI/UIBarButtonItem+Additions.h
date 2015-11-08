//
//  UIBarButtonItem+Additions.h
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Additions)

+ (id) barItemWithSystemItem: (UIBarButtonSystemItem) systemItem target: (id) target action: (SEL) action;
+ (id) itemWithTitle: (NSString*) title style: (UIBarButtonItemStyle) style target: (id) target
              action: (SEL) action;
+ (id) itemWithCustomView: (UIView*) view;

@end
