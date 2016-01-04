

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PlaceModel.h"
#import "OrderModel.h"
#import "StatisticModel.h"

typedef enum : NSUInteger {
    ServerCodeExpiredToken = 401,
    ServerCodeOk = 200|201,
    ServerCodeSystemError = 500,
    ServerCodeNoInternet = 1000,
} ServerCode;


@interface Server : NSObject <NSURLConnectionDelegate, NSURLSessionDelegate>

+ (instancetype)instance;

- (void)checkPhoneNumber:(NSString *)phone
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)checkForRecoveryPhoneNumber:(NSString *)phone
                            success:(void (^)(void))success
                            failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)signUpWithModel:(UserModel *) userModel
                success:(void (^)(UserModel *userModel))success
                failure:(void (^)(NSString *error, NSInteger code))failure;

- (void)loginWithModel:(UserModel *) userModel
               success:(void (^)(UserModel *userModel))success
               failure:(void (^)(NSError *error, NSInteger code))failure;

//- (void)searchPlace:(NSString *) adress
//            success:(void (^)(NSArray *placesArray))success
//            failure:(void (^)(NSError *error, NSString *status))failure;

- (void)getProfileSuccess:(void (^)(UserModel *userModel))success
                  failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)updateProfile:(UserModel *) userModel
          homeAddress:(PlaceModel *) homeAdress
          workAddress:(PlaceModel *) workAdress
              success:(void (^)(UserModel *userModel))success
              failure:(void (^)(NSError *error, NSInteger code))failure;


- (void) uploadImageFromPath:(NSString *) path
                     success:(void (^)(UserModel *userModel))success
                     failure:(void (^)(NSError *error, NSInteger code))failure;

- (void) uploadImage:(UIImage *) image
             success:(void (^)(UserModel *userModel))success
             failure:(void (^)(NSError *error, NSInteger code))failure;

//////// General ///////

- (void)checkSocialId:(id)socialId
              success:(void (^)(BOOL hasSocialId))success
              failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)supportPhoneSuccess:(void (^)(NSString *phoneNumber))success
                    failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)clearBadgesSuccess:(void (^)(void))success
                   failure:(void (^)(NSError *error, NSInteger code))failure;


//////// Courier ///////

- (void)statisticsByRange:(StatisticRange)range
                  success:(void (^)(StatisticModel *statistic))success
                  failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)rateCourier:(NSString *)courier
        withRaiting:(NSNumber *)rating
            success:(void (^)(void))success
            failure:(void (^)(NSError *error, NSInteger code))failure;

//- (void)trackingOrder:(OrderModel *)order
//              success:(void (^)(void))success
//              failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)updateOrder:(OrderModel *)order
         withStatus:(OrderStatus)status
            success:(void (^)(void))success
            failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)viewOrder:(OrderModel *)order
          success:(void (^)(void))success
          failure:(void (^)(NSError *error, NSInteger code))failure;

//////// Password ///////

- (void)updatePassword:(NSString *)psw
        forPhoneNumber:(NSString *)phoneNumber
               success:(void (^)(void))success
               failure:(void (^)(NSError *error, NSInteger code))failure;

/////// GOOGLE SDK //////

- (void)GMSSearchPlace:(NSString *) adress
               success:(void (^)(NSArray *placesArray))success
               failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)GMSUpdatePlace:(PlaceModel *)place
               success:(void (^)(void))success
               failure:(void (^)(NSError *error, NSInteger code))failure;

- (void)GMSCurrentPlaceSuccess:(void (^)(NSArray *places))success
                       failure:(void (^)(NSError *error, NSInteger code))failure;


@end