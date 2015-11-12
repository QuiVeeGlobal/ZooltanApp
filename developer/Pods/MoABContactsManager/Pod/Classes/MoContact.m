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

- (NSString *)phonesNumbers
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

- (NSArray *)addressValues
{
    if (_addresses && [_addresses count] > 0 ) {
        return [_addresses valueForKeyPath:@"@unionOfArrays.@allValues"];
    }
    return @[];
}

- (NSString*)addressInfo
{
    NSMutableString *addressInfo = [NSMutableString string];
    NSDictionary *address = self.addressValues.firstObject;
    
    if (address[@"Street"]) {
        [addressInfo appendString:address[@"Street"]];
    }
    if (address[@"City"]) {
        if (addressInfo.length) {
            [addressInfo appendString:@", "];
        }
        [addressInfo appendString:address[@"City"]];
    }
    
    if (address[@"Country"]) {
        if (addressInfo.length) {
            [addressInfo appendString:@", "];
        }
        [addressInfo appendString:address[@"Country"]];
    }
    
    return addressInfo;
}

- (NSDictionary *)asDictionary
{
    return [[MoContactSerializer sharedInstance] serializeContact:self];
}


@end
