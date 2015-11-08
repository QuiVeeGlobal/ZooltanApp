//
//  NSMutableURLRequest(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Additions)

/*!
 Fills in the `Authorization` header field for performing Basic auth.
 
 Note that Apple recommends against doing this in the latest docs.
 The URL loading system's authentication challenge approach can't quite
 handle this approach in some instances. You will receive an authentication
 challenge, but any fresh credentials you supply are ignored as the existing
 `Authorization` header appears to take precedence. Any failures have to be
 handled specially by clients outside of the authentication challenge system.
 
 Should only be used for HTTPS URLs too, as HTTP will expose the credential for anyone to snoop.
 
 @param username The Basic auth username. Must not contain a `:` character.
 @param password The Basic auth password.
 @param token The User token.
 */
- (void)setBasicAuthWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)setBasicAuthWithCredential:(NSURLCredential *)credential;
- (void)setBasicAuthWithToken:(NSString *)token;


- (void) setObject: (NSString*) value forKeyedSubscript: (NSString*) headerField;

@end