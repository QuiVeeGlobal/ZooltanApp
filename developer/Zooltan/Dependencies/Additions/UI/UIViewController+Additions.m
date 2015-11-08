//
//  UIViewController(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

+ (id) controllerFromStoryboard: (UIStoryboard*) storyboard
{
    return [storyboard instantiateViewControllerWithIdentifier: NSStringFromClass(self.class)];
}

@end