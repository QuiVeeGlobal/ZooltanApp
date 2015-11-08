//
//  UIView+Additions.m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+Additions.h"
#import "NSArray+Additions.h"

@implementation UIView (Additions)

@dynamic origin;

- (id) initWithParent: (UIView*) parent
{
	self = [self initWithFrame:CGRectZero];
	if (!self) 
		return nil;
	
	[parent addSubview:self];
	return self;
}

+ (id) viewWithParent: (UIView*) parent { return [[self alloc] initWithParent: parent]; }


- (CGPoint) position { return self.frame.origin; }
- (void) setPosition: (CGPoint) position
{
    self.center = CGPointMake(position.x + self.width / 2.0f,
                              position.y + self.height / 2.0f);
}

- (CGFloat) x { return self.center.x - self.width / 2.0f; }
- (void) setX: (CGFloat) x
{
    self.center = CGPointMake(x + self.width / 2.0f, self.center.y);
}

- (CGFloat) y { return self.center.y - self.height / 2.0f; }
- (void) setY: (CGFloat) y
{
    self.center = CGPointMake(self.center.x, y + self.height / 2.0f);
}

- (CGSize) size { return self.bounds.size; }
- (void) setSize: (CGSize) size
{
    CGRect rect = self.frame;
	rect.size = size;
    self.frame = rect;
}

- (CGFloat) width { return self.bounds.size.width; }
- (void) setWidth: (CGFloat) width
{
    CGRect rect = self.frame;
	rect.size.width = width;
    self.frame = rect;
}

- (CGFloat) height { return self.bounds.size.height; }
- (void) setHeight: (CGFloat) height
{
    CGRect rect = self.frame;
	rect.size.height = height;
    self.frame = rect;
}

- (CGFloat) right  { return self.x + self.width;  }
- (CGFloat) bottom { return self.y + self.height; }

- (void) setRight: (CGFloat) right
{
    [NSException raise: @"NotImplementedException" format: nil];

    //TODO reimplement

//    CGRect rect = self.frame;
//    rect.origin.x = right-rect.size.width;
//    self.frame = rect;
}

- (void) setBottom: (CGFloat) aBottom
{
    [NSException raise: @"NotImplementedException" format: nil];

    //TODO reimplement

//    self.y = aBottom - self.height;
}

//==================================================================================================
- (id) superviewOfClass: (Class) aClass
{
	UIView* parent = self.superview;
	while (![parent isKindOfClass: aClass] && parent)
		parent = parent.superview;
	return parent;
}

//==================================================================================================
- (id) subviewOfClass: (Class) aClass
{
	for (UIView* subview in self.subviews)
	{
		if ([subview isKindOfClass: aClass])
			return subview;
	}
	return nil;
}

//==================================================================================================
+ (id) subviewOfClass: (Class) aClass recursive: (BOOL) recursive inView: (UIView*) aView
{
	if (!aView.subviews.count)
		return nil;
	
	if (!recursive)
		return [aView subviewOfClass: aClass];
	
	for (UIView* subview in aView.subviews)
	{
		if ([subview isKindOfClass: aClass])
			return subview;
		
		UIView* result = [UIView subviewOfClass: aClass recursive: recursive inView: subview];
		if (result)
			return result;
	}
	return nil;
}

//==================================================================================================
- (id) subviewOfClass: (Class) aClass recursive: (BOOL) recursive
{
	if (!recursive)
		return [self subviewOfClass: aClass];
	
	return [UIView subviewOfClass: aClass recursive: recursive inView: self];
}

//==================================================================================================
- (void) printSubviewsRecursive: (BOOL) recursive
{
	[UIView printSubviewsInView: self recursive: recursive];
}

//==================================================================================================
+ (void) printSubviewsInView: (UIView*) aView recursive: (BOOL) recursive depth: (int) depth
{
#ifdef DEBUG

	if (!aView.subviews.count)
		return;
	
	NSMutableString* offset = [NSMutableString string];
	for (int i = 0; i != depth; i++)
		[offset appendString: @"	"];

	for (UIView* subview in aView.subviews)
	{
		CFShow((__bridge CFStringRef) [offset stringByAppendingString: subview.description]);
		if (recursive)
			[UIView printSubviewsInView: subview recursive: recursive depth: depth + 1];
	}
#endif
}

+ (void) printSubviewsInView: (UIView*) aView recursive: (BOOL) recursive
{
	[UIView printSubviewsInView: aView recursive: recursive depth: 0];
}

- (NSArray*) subviewsOfClass: (Class) aClass
{
    return [self.subviews objectsPassingTest: ^(id obj, NSUInteger idx, BOOL* stop)
                                              {
                                                  return [obj isKindOfClass: aClass];
                                              }];
}

- (id) subviewWithTag: (NSInteger) tag
{
    for (UIView* subview in self.subviews)
        if (subview.tag == tag)
            return subview;
    return nil;
}

- (void) insertSubview: (UIView*) view aboveSubviewPassingTest: (BOOL (^)(id obj)) predicate
{
	UIView* subview = [self.subviews firstObjectPassingTest: predicate];
	if (!subview)
		return;
	
	[self insertSubview: view aboveSubview: subview];
}

//==================================================================================================
- (UIView*) firstResponder
{
	if (self.isFirstResponder)
		return self;
	
	for (UIView* subview in self.subviews)
	{
		if (subview.isFirstResponder)
			return subview;
		UIView* responder = subview.firstResponder;
		if (responder)
			return responder;
	}
	return nil;
}

//==================================================================================================
- (void) centerInParent
{
	self.x = (self.superview.width  - self.width)  / 2.0f;
	self.y = (self.superview.height - self.height) / 2.0f;
}

- (void) centerInParentRounded
{
	self.x =roundf( (self.superview.width  - self.width)  / 2.0f);
	self.y =roundf( (self.superview.height - self.height) / 2.0f);
}

//==================================================================================================
- (void) centerInParentVertical
{
	self.y = (self.superview.height - self.height) / 2.0f;
}

//==================================================================================================
- (void) centerInParentHorizontal
{
	self.x = (self.superview.width  - self.width)  / 2.0f;
}

//==================================================================================================
- (void) stretchRight: (CGFloat) rightCoordinate
{
    self.width += rightCoordinate - self.right;
}

//==================================================================================================
- (void) moveAllSubviews: (CGPoint) offset
{
    for (UIView* subview in self.subviews)
    {
        subview.x += offset.x;
        subview.y += offset.y;
    }
}

//==================================================================================================
- (CGPoint) convertOriginToView: (UIView*) aView
{
    return [self.superview convertPoint: self.origin toView: aView];
}

// Translate origin.y by height either up or down
-(void) translateYByHeight:(BOOL)up
{
    if(up)
        self.y = self.y - self.height;
    else
        self.y = self.y + self.height;
}

- (NSComparisonResult) compareByTag: (UIView*) otherView
{
    if (self.tag < otherView.tag)
        return NSOrderedAscending;
    if (self.tag > otherView.tag)
        return NSOrderedDescending;
    return NSOrderedSame;
}

@end

//==================================================================================================
@implementation UIView (Animations)

+ (void) APAnimateWithDuration: (NSTimeInterval) duration animations: (void (^)(void)) animations
{
    if (duration <= 0.0)
        animations();
    else
        [UIView animateWithDuration: duration animations: animations];
}

//==================================================================================================
+ (void) APAnimateWithDuration: (NSTimeInterval) duration animations: (void (^)(void)) animations
                    completion: (void (^)(BOOL finished)) completion
{
    if (duration <= 0.0)
    {
        animations();
        completion(YES);
    }
    else
        [UIView animateWithDuration: duration animations: animations completion: completion];
}

//==================================================================================================
+ (void) APAnimateWithDuration: (NSTimeInterval) duration options: (UIViewAnimationOptions) options
                  animations: (void (^)(void)) animations
{
    if (duration <= 0.0)
        animations();
    else
        [UIView animateWithDuration: duration delay: 0.0 options: options animations: animations
                         completion: NULL];
}

//==================================================================================================
+ (void) APAnimateWithDuration: (NSTimeInterval) duration delay: (NSTimeInterval) delay
                       options: (UIViewAnimationOptions) options
                    animations: (void (^)(void)) animations
                    completion: (void (^)(BOOL finished)) completion
{
    if (duration <= 0.0 && delay <= 0.0)
    {
        animations();
        if (completion)
            completion(YES);
    }
    else
        [UIView animateWithDuration: duration delay: delay options: options animations: animations
                         completion: completion];
}

@end

