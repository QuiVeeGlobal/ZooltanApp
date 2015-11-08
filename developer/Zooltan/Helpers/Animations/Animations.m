//
//  Animations.m
//  CarLifeStory
//
//  Created by Eugene Vegner on 24.07.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "Animations.h"

@implementation Animations

+ (CAAnimation *)animateNafigationCtrl {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    return transition;
}

+ (CAAnimation *)animationToLeft {
    CABasicAnimation* transition = [CABasicAnimation animationWithKeyPath:@"position.x"];
    transition.duration = 10;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //transition.type = kCATransitionMoveIn;
    //transition.subtype = kCATransitionFromRight;
    return transition;
}

+ (CAAnimation *)animationFromBottom {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.33;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}

//+ (CATransform3D)animationScroll
//{
//    CATransform3D transform = CATransform3DIdentity;
//        CGFloat distance = 320;
//        if (percentVisible <= 1.f) {
//            transform = CATransform3DMakeTranslation((-distance)/1.0+(distance*percentVisible/parallaxFactor), 0.0, 0.0);
//        }
//        else{
//            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
//            transform = CATransform3DTranslate(transform, drawerController.maximumLeftDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
//        }
//    }
//    else if(drawerSide == MMDrawerSideRight){
//        sideDrawerViewController = drawerController.rightDrawerViewController;
//        CGFloat distance = MAX(drawerController.maximumRightDrawerWidth,drawerController.visibleRightDrawerWidth);
//        if(percentVisible <= 1.f){
//            transform = CATransform3DMakeTranslation((distance)/parallaxFactor-(distance*percentVisible)/parallaxFactor, 0.0, 0.0);
//        }
//        else{
//            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
//            transform = CATransform3DTranslate(transform, -drawerController.maximumRightDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
//        }
//    }
//    return tr
//   // [sideDrawerViewController.view.layer setTransform:transform];
//}


@end
