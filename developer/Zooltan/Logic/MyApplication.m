//
//  Colors.m
//  RunCoachM
//
//  Created by Eugene Vegner on 29.09.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "MyApplication.h"
//#import <Lock/Lock.h>

@implementation MyApplication

+ (MyApplication*)sharedInstance {
    static MyApplication *sharedApplication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApplication = [[self alloc] init];
    });
    return sharedApplication;
}

//- (id)init {
//    self = [super init];
//    if (self) {
//        _lock = [A0Lock newLock];
//    }
//    return self;
//}
@end
