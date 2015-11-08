//
//  CheckMobi.h
//  Zooltan
//
//  Created by Eugene Vegner on 22.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CheckMobiCompletionBlock)(NSError *error);

@interface CheckMobi : NSObject

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *validationKey;
@property (nonatomic, assign) BOOL pinStep;
@property (nonatomic, assign) NSError *error;

+ (instancetype)instance;
- (void)start;

- (void)verifyPhoneNumber:(NSString *)phoneNumber
          completionBlock:(CheckMobiCompletionBlock)block;

- (void)validatePinCode:(NSString *)pincode
        completionBlock:(CheckMobiCompletionBlock)block;

@end
