//
//  MoContact.m
//  MoABContactsManagerDemo
//
//  Created by Diego Pais on 6/9/15.
//  Copyright (c) 2015 mostachoio. All rights reserved.
//

#import "MoContact.h"
#import "MoContactSerializer.h"

@implementation MoContact


- (NSArray *)emailsValues
{
    if (_emails && [_emails count] > 0 ) {
        return [_emails valueForKeyPath:@"@unionOfArrays.@allValues"];
    }
    return @[];
}

- (NSArray *)phonesValues
{
    if (_phones && [_phones count] > 0 ) {
        return [_phones valueForKeyPath:@"@unionOfArrays.@allValues"];
    }
    return @[];
}

- (NSString*)phonesNumbers
{
    NSMutableString *phonesNumbers = [NSMutableString string];
    
    for (NSString *phone in self.phonesValues) {
        [phonesNumbers appendString:phone];
    }
    
    NSString *phonesString = [phonesNumbers stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phonesString = [phonesString stringByReplacingOccurrencesOfString:@")" withString:@""];
    phonesString = [phonesString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phonesString = [phonesString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return phonesString;
}

- (NSDictionary *)asDictionary
{
    return [[MoContactSerializer sharedInstance] serializeContact:self];
}


@end
