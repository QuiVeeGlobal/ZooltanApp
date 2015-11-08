//
//  BaseNavigationCtrlDelegate.m
//  Travel
//
//  Created by Eugene Vegner on 17.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "BaseNavigationCtrlDelegate.h"

@implementation BaseNavigationCtrlDelegate

- (void)awakeFromNib {
    
    self.pushAnimation = [PushAnimation new];
    self.popAnimation = [PopAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    switch (operation)
    {
        case UINavigationControllerOperationPush:   return self.pushAnimation;
        case UINavigationControllerOperationPop:    return self.popAnimation;
        default: return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.interactionController;
}


@end
