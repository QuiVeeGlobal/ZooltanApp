//
//  NSMutableURLRequest(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSMutableURLRequest+Additions.h"

@implementation NSMutableURLRequest (Additions)

- (void)setBasicAuthWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    [self setValue:authValue forHTTPHeaderField:@"Authorization"];
}

- (void)setBasicAuthWithCredential:(NSURLCredential *)credential {
    [self setBasicAuthWithUsername:credential.user
                       andPassword:credential.password];
}

- (void)setBasicAuthWithToken:(NSString *)token {
    NSString *authStr = [NSString stringWithFormat:@"token:%@", token];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    [self setValue:authValue forHTTPHeaderField:@"Authorization"];
}


- (void) setObject: (NSString*) value forKeyedSubscript: (NSString*) headerField
{
    [self setValue: value forHTTPHeaderField: headerField];
}

@end