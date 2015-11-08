//
//  UITextField+Additions.m
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "UITextField+Additions.h"

@implementation UITextField (Additions)

- (BOOL)isEmpty {
    if (self.text.length > 0) {
        return NO;
    }
    return YES;
}

@end
