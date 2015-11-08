//
//  Colors.h
//  RunCoachM
//
//  Created by Eugene Vegner on 29.09.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class A0Lock;

@interface MyApplication : NSObject

@property (readonly, nonatomic) A0Lock *lock;

+ (MyApplication *)sharedInstance;

@end
