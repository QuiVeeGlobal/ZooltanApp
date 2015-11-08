//
//  Errors.h
//  Zooltan
//
//  Created by Eugene Vegner on 22.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultErrorCode 5000

@interface Errors : NSObject

+ (NSError *)defaultErrorWithMessage:(NSString *)message;

@end
