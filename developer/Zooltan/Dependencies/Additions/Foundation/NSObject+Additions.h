//
//  NSObject(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Additions)

+ (NSString *)className;
- (NSString *)className;

+ (id)instanceWithXib:(NSString *)xibName;
+ (id)instanceFromXib;

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;


@end