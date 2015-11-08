//
//  CheckMobi.m
//  Zooltan
//
//  Created by Eugene Vegner on 22.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "CheckMobi.h"
#import "CheckMobiService.h"

@interface CheckMobi()

@property (nonatomic, copy) CheckMobiCompletionBlock completionBlock;

@end

@implementation CheckMobi

+ (instancetype)instance
{
    static CheckMobi *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CheckMobi alloc] init];
    });
    return instance;
}

- (void)start
{
    [[CheckMobiService sharedInstance] setBaseUrl:[Constants checkMobiBaseUrl]];
    [[CheckMobiService sharedInstance] setSecretKey:[Constants checkMobiSecretKey]];
}

#pragma mark - Actions 

- (void)verifyPhoneNumber:(NSString *)phoneNumber completionBlock:(CheckMobiCompletionBlock)block
{
    self.completionBlock = block;
    
    [[CheckMobiService sharedInstance] RequestValidation:ValidationTypeSMS
                                               forNumber:phoneNumber
                                            withResponse:^(NSInteger status, NSDictionary* result, NSError* error)
     {
         STLogDebug(@"status= %ld result=%@", (long)status, result);
         if(status == kStatusSuccessWithContent && result != nil) {
             
             NSString* key = [result objectForKey:@"id"];
             self.phoneNumber = [[result objectForKey:@"validation_info"] objectForKey:@"formatting"];
             
             [self performPinValidation:key];
             
         } else
             [self handleValidationServiceError:status withBody:result withError:error];
         
         if (status == kStatusBadRequest && result != nil) {
             if (self.completionBlock) {
                 [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPhoneNumber", nil) target:self];
             }
         } else {
             if (self.completionBlock) {
                 self.completionBlock(nil);
             }
         }
     }];
}

- (void)validatePinCode:(NSString *)pincode completionBlock:(CheckMobiCompletionBlock)block
{
    STLogMethod;
    
    self.completionBlock = block;
    
    [[CheckMobiService sharedInstance] VerifyPin:self.validationKey
                                         withPin:pincode
                                    withResponse:^(NSInteger status, NSDictionary * result, NSError* error)
     {
         if(status == kStatusSuccessWithContent && result != nil) {
             
             NSNumber *validated = [result objectForKey:@"validated"];
             
             STLogDebug(@"result: %@", result);
             
             if(![validated boolValue]) {
                 if (self.completionBlock) {
                     [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPinCode", nil) target:self];
                 }
             } else {
                 if (self.completionBlock) {
                     self.completionBlock(nil);
                 }
             }
             
         } else
             [self handleValidationServiceError:status withBody:result withError:error];
     }];
}

- (void)performPinValidation:(NSString *)key {
    self.validationKey = key;
    self.pinStep = true;
}

- (void)resetParam {
    STLogMethod;
    self.validationKey = nil;
    self.pinStep = false;
    self.phoneNumber = @"";
}

- (void)handleValidationServiceError:(NSInteger)http_status
                            withBody:(NSDictionary *)body
                           withError:(NSError *)error
{
    STLogDebug(@"HandleValidationServiceError: status= %d body: %@ error: %@", (int) http_status, body, error);
    
    if(body)
    {
        NSString *error_message;
        enum ErrorCode error = (enum ErrorCode)[[body valueForKey:@"code"] intValue];
        
        switch (error)
        {
            case ErrorCodeInvalidPhoneNumber:
                error_message = @"Invalid phone number. Please provide the number in E164 format.";
                break;
                
            default:
                error_message = @"Service unavailable. Please try later.";
        }
        STLogDebug(@"error_message: %@",error_message);
    }
    else
        STLogDebug(@"Service unavailable. Please try later.");
}


@end
