//
//  NSString(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString*) trim;
- (BOOL) isNumber;
- (BOOL) isEmail;

// Crypto
- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha224;
- (NSString *)sha256;
- (NSString *)sha384;
- (NSString *)sha512;

@end