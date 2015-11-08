//
//  UIView(CoreAnimationAdditions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "UIView+CoreAnimationAdditions.h"

@implementation UIView (CoreAnimationAdditions)

- (void) setAnchorPointMaintainingPosition: (CGPoint) anchorPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x,
            self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x,
            self.bounds.size.height * self.layer.anchorPoint.y);

    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);

    CGPoint position = self.layer.position;

    position.x -= oldPoint.x;
    position.x += newPoint.x;

    position.y -= oldPoint.y;
    position.y += newPoint.y;

    self.layer.position    = position;
    self.layer.anchorPoint = anchorPoint;
}

@end