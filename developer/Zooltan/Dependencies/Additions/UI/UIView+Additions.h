//
//  UIView+Additions.h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (id) initWithParent:(UIView *)parent;
+ (id) viewWithParent:(UIView *)parent;

// Position of the top-left corner in superview's coordinates
@property CGPoint origin;
@property CGFloat x;
@property CGFloat y;

// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, readonly) UIView* firstResponder;

- (id) superviewOfClass:  (Class) aClass;
- (id) subviewOfClass:	  (Class) aClass;
- (id) subviewOfClass:	  (Class) aClass recursive: (BOOL) recursive;
+ (id) subviewOfClass:	  (Class) aClass recursive: (BOOL) recursive inView: (UIView*) aView;
- (NSArray*) subviewsOfClass: (Class) aClass;
- (id) subviewWithTag: (NSInteger) tag;

- (void) printSubviewsRecursive: (BOOL) recursive;
+ (void) printSubviewsInView: (UIView*) aView recursive: (BOOL) recursive;

- (void) insertSubview: (UIView*)view aboveSubviewPassingTest: (BOOL (^)(id obj)) predicate;

- (void) centerInParent;
- (void) centerInParentVertical;
- (void) centerInParentHorizontal;

- (void) centerInParentRounded;

- (void) stretchRight: (CGFloat) rightCoordinate;

- (void) moveAllSubviews: (CGPoint) offset;

- (CGPoint) convertOriginToView: (UIView*) aView;

- (void) translateYByHeight: (BOOL) up;

- (NSComparisonResult) compareByTag: (UIView*) otherView;

@end

/** These category methods execute animation blocks immediately if duration is less or equal to 0 */
@interface UIView (Animations)

+ (void) APAnimateWithDuration: (NSTimeInterval) duration animations: (void (^)(void)) animations;

+ (void) APAnimateWithDuration: (NSTimeInterval) duration animations: (void (^)(void)) animations
                    completion: (void (^)(BOOL finished)) completion;

+ (void) APAnimateWithDuration: (NSTimeInterval) duration options: (UIViewAnimationOptions) options
                    animations: (void (^)(void)) animations;

+ (void) APAnimateWithDuration: (NSTimeInterval) duration delay: (NSTimeInterval) delay
                       options: (UIViewAnimationOptions) options
                    animations: (void (^)(void)) animations
                    completion: (void (^)(BOOL finished)) completion;
@end

