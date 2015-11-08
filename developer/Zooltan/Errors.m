//
//  Errors.m
//  Zooltan
//
//  Created by Eugene Vegner on 22.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "Errors.h"

@implementation Errors

+ (NSError *)defaultErrorWithMessage:(NSString *)message {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = NIL_TO_NULL(message);
    
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:kDefaultErrorCode userInfo:userInfo];
}

@end
