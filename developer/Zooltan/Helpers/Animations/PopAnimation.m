//
//  STPopTransitioning.m
//  CarLifeStory
//
//  Created by Eugene Vegner on 27.08.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "PopAnimation.h"

#define kAnimatedTransitionDuration 0.2f

@implementation PopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kAnimatedTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIViewController *toViewController =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView * fromView = fromViewController.view;
    UIView * toView = toViewController.view;
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    // Position it off screen.
    toView.frame = CGRectMake( -width , viewSize.origin.y, width, viewSize.size.height);
    
    [UIView animateWithDuration:0.33 animations: ^{
         // Animate the views on and off the screen. This will appear to slide.
         fromView.frame = CGRectMake( width , viewSize.origin.y, width, viewSize.size.height);
         toView.frame = CGRectMake(0, viewSize.origin.y, width, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             // Remove the old view from the tabbar view.
             [fromView removeFromSuperview];
             [transitionContext completeTransition:YES];
         }
     }];
}


@end
