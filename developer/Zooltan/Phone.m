//
//  Phone.m
//  Zooltan
//
//  Created by Eugene on 30.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "Phone.h"

#define kMinPhoneLength 9
#define kMaxPhoneLength 10
#define DIG_RANGE(_min,_max) [self phoneRange:_min or:_max]

@interface Phone ()
{
    BOOL _isLongPhoneNumber;
    NSInteger _digits;
    NSInteger _length;
}

@end


@implementation Phone

+ (instancetype)instance {
    static Phone *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Phone alloc] init];
    });
    return instance;
}

- (BOOL)configurePhoneNumberFromTextField:(UITextField *)textField withCharactersInRange:(NSRange)range string:(NSString *)string {

    NSInteger t = [self getPhoneLength:textField.text] + [self getPhoneLength:string] - range.length;
    if (t >= kMaxPhoneLength+1) {
        return NO;
    }

    NSString *fullString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    BOOL deleteLastChar = (range.length == 1);
    if (deleteLastChar) {
        fullString = [NSString stringWithFormat:@"%@%@",textField.text,@""];
        //fullString = [fullString substringToIndex:[fullString length] - 1];
    }
    
    NSString *phoneString = [self clearPhoneNumber:fullString];
    NSString *num = [self formatPhomeNumber:phoneString];
    
    _length = [self getPhoneLength:num];
    _isLongPhoneNumber = (_length >= kMaxPhoneLength+1);
    
    if (_isLongPhoneNumber && range.length == 0) {
        return NO;
    }

    if (![textField.text hasPrefix:kPhoneCodePrefix]) {
        textField.text = [NSString stringWithFormat:@"%@ %@",kPhoneCodePrefix, num];
    }
    if (range.location < 4) {
        return NO;
    }
    
    if (_length == 1 && _length < 3) {
        textField.text = [NSString stringWithFormat:@"%@ %@",
                          kPhoneCodePrefix,
                          [num substringFromIndex:1]];
    }
    
    else if (_length == 3 && _length < 7) {
        textField.text = [NSString stringWithFormat:@"%@ %@ %@",
                          kPhoneCodePrefix,
                          [num substringToIndex:2],
                          [num substringFromIndex:3]];
    }
    
    else if (_length == 7 && _length < kMaxPhoneLength)
    {
        textField.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                          kPhoneCodePrefix,
                          [num substringToIndex:2],
                          [num substringWithRange:NSMakeRange(2, 4)],
                          [num substringFromIndex:7]];
    }
    
//    else if (_length == 9 && _length < kMaxPhoneLength)
//    {
//        textField.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
//                          kPhoneCodePrefix,
//                          [num substringToIndex:2],
//                          [num substringWithRange:NSMakeRange(2, 3)],
//                          [num substringWithRange:NSMakeRange(5, 2)],
//                          [num substringFromIndex:8]];
//        //        if (deleteLastChar) {
//        //            textField.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
//        //                              kPhoneCodePrefix,
//        //                              [num substringToIndex:2],
//        //                              [num substringWithRange:NSMakeRange(2, 3)],
//        //                              [num substringWithRange:NSMakeRange(5, 2)],
//        //                              [num substringFromIndex:8]];
//        //        }
//    }
    
    else if (_length == kMaxPhoneLength)
    {
        textField.text = [NSString stringWithFormat:@"%@ %@ %@ %@%@",
                          kPhoneCodePrefix,
                          [num substringToIndex:3],
                          [num substringWithRange:NSMakeRange(3, 4)],
                          [num substringWithRange:NSMakeRange(7, 2)],
                          //[num substringWithRange:NSMakeRange(9, 1)],
                          [num substringFromIndex:10]];
        
        if (deleteLastChar) {
            textField.text = [NSString stringWithFormat:@"%@ %@ %@ %@%@",
                              kPhoneCodePrefix,
                              [num substringToIndex:2],
                              [num substringWithRange:NSMakeRange(2, 4)],
                              [num substringWithRange:NSMakeRange(6, 2)],
                              [num substringFromIndex:8]];
        }
    }
    
    return YES;
}

- (NSString *)formatPhomeNumber:(NSString *)phoneNumber {
    phoneNumber = [self clearPhoneNumber:phoneNumber];
    NSInteger length = [phoneNumber length];
    if(length > kMaxPhoneLength) {
        phoneNumber = [phoneNumber substringFromIndex: length-kMaxPhoneLength];
    }
    return phoneNumber;
}

- (NSInteger)getPhoneLength:(NSString *)phoneNumber {
    phoneNumber = [self clearPhoneNumber:phoneNumber];
    return [phoneNumber length];
}

- (NSString *)clearPhoneNumber:(NSString *)phoneNumber {
    
    if ([phoneNumber hasPrefix:kPhoneCodePrefix]) {
        phoneNumber = [phoneNumber substringFromIndex:4];
    }
    
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    //STLogDebug(@"Cleaned phone number: %@ [%zd]", phoneNumber, phoneNumber.length);
    return phoneNumber;
}

- (NSInteger)phoneRange:(NSInteger)aRange or:(NSInteger)bRange {
    return (_digits == 10)?bRange:aRange;
}

@end
