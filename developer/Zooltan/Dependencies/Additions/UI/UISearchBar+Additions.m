//
//  UISearchBar+Additions.m
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "UISearchBar+Additions.h"

@implementation UISearchBar (Additions)

- (UIButton *)cancelButton {
    return [self.subviews firstObjectPassingTest: ^(id obj) {
        return [obj isKindOfClass: UIButton.class];
    }];
}

@end
