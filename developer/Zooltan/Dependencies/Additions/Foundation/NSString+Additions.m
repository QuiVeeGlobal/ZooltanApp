//
//  NSString(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

static inline NSString *NSStringCCHashFunction(unsigned char *(function)(const void *data, CC_LONG len, unsigned char *md), CC_LONG digestLength, NSString *string)
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[digestLength];
    
    function(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:digestLength * 2];
    
    for (int i = 0; i < digestLength; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@implementation NSString (Additions)

- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceCharacterSet];
}

- (BOOL) isNumber
{
    return [self rangeOfCharacterFromSet: [NSCharacterSet.decimalDigitCharacterSet invertedSet]].location == NSNotFound;
}

- (BOOL) isEmail
{
    NSString* emailRegEx = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                           @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                           @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                           @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                           @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                           @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                           @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate* regExPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject: self];
}

#pragma mark - Crypto

- (NSString *)md5
{
    return NSStringCCHashFunction(CC_MD5, CC_MD5_DIGEST_LENGTH, self);
}

- (NSString *)sha1
{
    return NSStringCCHashFunction(CC_SHA1, CC_SHA1_DIGEST_LENGTH, self);
}

- (NSString *)sha224
{
    return NSStringCCHashFunction(CC_SHA224, CC_SHA224_DIGEST_LENGTH, self);
}

- (NSString *)sha256
{
    return NSStringCCHashFunction(CC_SHA256, CC_SHA256_DIGEST_LENGTH, self);
}

- (NSString *)sha384
{
    return NSStringCCHashFunction(CC_SHA384, CC_SHA384_DIGEST_LENGTH, self);
}

- (NSString *)sha512
{
    return NSStringCCHashFunction(CC_SHA512, CC_SHA512_DIGEST_LENGTH, self);
}


@end