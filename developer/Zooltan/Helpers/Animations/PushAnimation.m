//
//  PushAnimation.m
//  CarLifeStory
//
//  Created by Eugene Vegner on 26.08.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "PushAnimation.h"

#define kAnimatedTransitionDuration 0.2f

@implementation PushAnimation

//- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
//{
//    return 1;
//}
//
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    [[transitionContext containerView] addSubview:toViewController.view];
//    toViewController.view.alpha = 0;
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        toViewController.view.alpha = 1;
//    } completion:^(BOOL finished) {
//        fromViewController.view.transform = CGAffineTransformIdentity;
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        
//    }];
//}
//


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kAnimatedTransitionDuration;
}

//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    UIView *container = [transitionContext containerView];
//    
//    //if (self.reverse)
//    //{
//    //    [container insertSubview:toViewController.view belowSubview:fromViewController.view];
//    //}
//    //else {
//        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
//        [container addSubview:toViewController.view];
//    //}
//    
//    [UIView animateKeyframesWithDuration:STAnimatedTransitionDuration delay:0 options:0 animations:^
//     {
//         //if (self.reverse)
//         //{
//         //    fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
//         //}
//         //else
//         //{
//             toViewController.view.transform = CGAffineTransformIdentity;
//        // }
//     } completion:^(BOOL finished)
//     {
//         [transitionContext completeTransition:finished];
//     }];
//}

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
    
    // Add the toView to the fromView
    [fromView.superview addSubview:toView];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    // Position it off screen.
    toView.frame = CGRectMake( width , viewSize.origin.y, width, viewSize.size.height);
    
    [UIView animateWithDuration:0.33 animations: ^{
         // Animate the views on and off the screen. This will appear to slide.
         fromView.frame =CGRectMake( -width , viewSize.origin.y, width, viewSize.size.height);
         toView.frame =CGRectMake(0, viewSize.origin.y, width, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             // Remove the old view from its parent.
             [fromView removeFromSuperview];
             
             [transitionContext completeTransition:YES];

             
             //I use it to have navigationnBar and TabBar at the same time
             //self.tabBarController.selectedIndex = indexPath.row+1;
         }
     }];
}

//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    UIView * fromView = fromViewController.view;
//    UIView * toView = toViewController.view;
//    
//    // Get the size of the view area.
//    CGRect viewSize = fromView.frame;
//    
//    // Add the to view to the tab bar view.
//    [fromView.superview addSubview:toView];
//    
//    // Position it off screen.
//    toView.frame = CGRectMake( -320 , viewSize.origin.y, 320, viewSize.size.height);
//    
//    [UIView animateWithDuration:0.4 animations:
//     ^{
//         // Animate the views on and off the screen. This will appear to slide.
//         fromView.frame =CGRectMake( 320 , viewSize.origin.y, 320, viewSize.size.height);
//         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
//     }
//                     completion:^(BOOL finished)
//     {
//         if (finished)
//         {
//             // Remove the old view from the tabbar view.
//             [fromView removeFromSuperview];
//         }
//     }];
//
//}
@end
