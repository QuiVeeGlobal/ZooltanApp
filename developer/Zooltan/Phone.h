//
//  Phone.h
//  Zooltan
//
//  Created by Eugene on 30.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Phone : NSObject

+ (instancetype)instance;
// Phone Number
- (BOOL)configurePhoneNumberFromTextField:(UITextField *)textField withCharactersInRange:(NSRange)range string:(NSString *)string;
- (NSString *)formatPhomeNumber:(NSString *)phoneNumber;

@end
