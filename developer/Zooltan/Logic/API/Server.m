

#import "Server.h"
//#import "Reachability.h"
#import "AFNetworking.h"
#import "ResponseModel.h"
#import "UserModel.h"

#define REQUEST self.manager

@interface Server ()
@property (nonatomic, strong) dispatch_queue_t privateQueue;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation Server

+ (instancetype)instance
{
    static Server *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Server alloc] init];
    });
    return instance;
}

NSString *URLMethod(NSString *rout) {
    NSString *path = [NSString stringWithFormat:@"/"];
    path = [path stringByAppendingPathComponent:
            (IS_COURIER_APP) ? @"courier" : @"client"];
    return [path stringByAppendingPathComponent:rout];
}



#pragma mark - Default

- (void)checkPhoneNumber:(NSString *)phone
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error, NSInteger code))failure {
    
    //phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *method = @"check-phone-existence";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = STRING(phone);
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        PRTSuccessOperation(operation);
        @try { success();}
        @catch (NSException *exception) { STLogException(exception); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
    
//    [REQUEST GET:method parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        PRTSuccessOperation(operation);
//        
//
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            
//            [(NSArray*)responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                STLogDebug(@"<--- %@",obj);
//            }];
//            
//            
//            
//        } else {
////            if (failure) {
////                failure([Errors defaultErrorWithMessage:@"User not found"],409);
////            }
//        }
//        
//        
//        
//        if (success) {
//            success();
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        PRTFailureOperation(operation);
//        @try { failure (error, operation.response.statusCode); }
//        @catch (NSException *exception) { STLogException(exception); }
//    }];
}


- (void)checkForRecoveryPhoneNumber:(NSString *)phone
                            success:(void (^)(void))success
                            failure:(void (^)(NSError *error, NSInteger code))failure {
    
    phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *method = @"/user/recovery";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = STRING(phone);
    
    PRTParameters(param, URLMethod(method));
    
    //[REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:method parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            __block BOOL hasRole = NO;
            [(NSArray*)responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (IS_COURIER_APP) {
                    if ([obj isEqualToString:@"ROLE_COURIER"]) {
                        hasRole = YES;
                    }
                } else {
                    if ([obj isEqualToString:@"ROLE_CLIENT"]) {
                        hasRole = YES;
                    }
                }
            }];
            
            if (hasRole) {
                if (success) {
                    success();
                }
            } else {
                if (failure) {
                    failure([Errors defaultErrorWithMessage:@"User not found"],404);
                }
            }
        } else {
            if (failure) {
                failure([Errors defaultErrorWithMessage:@"User not found"],404);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}


#pragma mark ------------------------------------------------- ACL --------------------------------------------------------------------------------
#pragma mark - SignUp (/client/acl/auth/sign_up)
#pragma mark -

- (void)signUpWithModel:(UserModel *) userModel
                success:(void (^)(UserModel *userModel))success
                failure:(void (^)(NSString *error, NSInteger code))failure
{
    
    NSDictionary *param = nil;
    @try
    {
        if (userModel.isFB)
        {
            param = @{@"password":userModel.socialId,
                      @"name":userModel.name,
                      @"phone":userModel.phone,
                      @"social":userModel.socialId,
                      @"logo":userModel.avatarURL,
                      @"device_id":userModel.deviceId};
        }
        else
        {
            param = @{@"password":userModel.password,
                      @"name":userModel.name,
                      @"phone":userModel.phone,
                      @"device_id":userModel.deviceId};
        }
        
    }
    @catch (NSException *exception) { STLogException(exception); }
    
    STLogInfo(@"/client/registration PARAM: %@",param);
    
    [REQUEST POST:@"/client/registration" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"formData %@", formData);
    }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        STLogSuccess(@"/client/registration RESPONSE: %@",responseObject);
        //ResponseModel *response = [[ResponseModel alloc] initWithResponseData:responseObject];
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201)
        {
            NSString *token = responseObject[@"token"];
            [[Settings instance] setToken:token];
            
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            
            PlaceModel *workModel = [[PlaceModel alloc] initWithWorkDictionary:responseObject];
            PlaceModel *homeModel = [[PlaceModel alloc] initWithHomeDictionary:responseObject];
            
            [[Settings instance] setHomeAddress:homeModel];
            [[Settings instance] setWorkAddress:workModel];
            
            success(userModel);
        }
        else
            failure(nil, operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        STLogSuccess(@"/client/registration ERROR: %@",operation.responseString);
        failure(operation.responseString, operation.response.statusCode);
    }];
}

#pragma mark - Login
#pragma mark -

- (void)loginWithModel:(UserModel *) userModel
               success:(void (^)(UserModel *userModel))success
               failure:(void (^)(NSError *error, NSInteger code))failure
{
    NSDictionary *param = nil;
    @try
    {
        if (userModel.isFB)
        {
            param = @{@"id":userModel.socialId,
                      @"hash":userModel.socialHash,
                      @"device_id":userModel.deviceId};
        }
        else
        {
            param = @{@"phone":userModel.phone,
                      @"password":userModel.password,
                      @"device_id":userModel.deviceId};
        }
    }
    @catch (NSException *exception) { STLogException(exception); }
    
    STLogInfo(@"%@ PARAM: %@",URLMethod(@"login"), param);
    
    [REQUEST POST:URLMethod(@"login") parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"formData %@", formData);
    }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        STLogSuccess(@"%@ RESPONSE: %@",URLMethod(@"login"), responseObject);
        
        //ResponseModel *response = [[ResponseModel alloc] initWithResponseData:responseObject];
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201)
        {
            NSString *token = responseObject[@"token"];
            [[Settings instance] setToken:token];
            
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            
            PlaceModel *workModel = [[PlaceModel alloc] initWithWorkDictionary:responseObject];
            PlaceModel *homeModel = [[PlaceModel alloc] initWithHomeDictionary:responseObject];
            
            [[Settings instance] setHomeAddress:homeModel];
            [[Settings instance] setWorkAddress:workModel];
            
            success(userModel);
        }
        else
            failure(nil, operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        STLogSuccess(@"%@ failure: %@",URLMethod(@"login"),operation.responseString);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

#pragma mark - GetProfile
#pragma mark -

- (void)getProfileSuccess:(void (^)(UserModel *userModel))success
                  failure:(void (^)(NSError *error, NSInteger code))failure
{
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:URLMethod(@"profile") parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         STLogSuccess(@"%@ RESPONSE: %@",URLMethod(@"profile"),responseObject);
         ResponseModel *response = [[ResponseModel alloc] initWithResponseData:responseObject];
         
         if (operation.response.statusCode == 200 || operation.response.statusCode == 201)
         {
             NSString *token = responseObject[@"token"];
             [[Settings instance] setToken:token];
             
             UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
             
             PlaceModel *workModel = [[PlaceModel alloc] initWithWorkDictionary:responseObject];
             PlaceModel *homeModel = [[PlaceModel alloc] initWithHomeDictionary:responseObject];
             
             [[Settings instance] setHomeAddress:homeModel];
             [[Settings instance] setWorkAddress:workModel];
             
             success(userModel);
         }
         else
             failure(nil, response.code);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         STLogSuccess(@"%@ failure: %@",URLMethod(@"profile"), operation.responseString);
         ResponseModel *response = [[ResponseModel alloc] initWithResponseData:operation.responseData];
         @try { failure (error, response.code); }
         @catch (NSException *exception) { STLogException(exception); }
     }];
}

#pragma mark - getProfile (/client/profile/update)
#pragma mark -

- (void)updateProfile:(UserModel *) userModel
          homeAddress:(PlaceModel *) homeAdress
          workAddress:(PlaceModel *) workAdress
              success:(void (^)(UserModel *userModel))success
              failure:(void (^)(NSError *error, NSInteger code))failure
{

    NSDictionary *param = nil;
    @try
    {
        if (homeAdress && workAdress && homeAdress != NULL && workAdress != NULL)
        {
            if (userModel.password.length == 0 || userModel.nPassword.length == 0)
            {
                param = @{@"name":userModel.name,
                          @"phone":userModel.phone,
                          @"home_address":homeAdress.formatted_address,
                          @"home_address_lat":[NSString stringWithFormat:@"%f", homeAdress.location.latitude],
                          @"home_address_lon":[NSString stringWithFormat:@"%f", homeAdress.location.longitude],
                          @"work_address":workAdress.formatted_address,
                          @"work_address_lat":[NSString stringWithFormat:@"%f", workAdress.location.latitude],
                          @"work_address_lon":[NSString stringWithFormat:@"%f", workAdress.location.longitude]};
            }
            else
                param = @{@"name":userModel.name,
                          @"phone":userModel.phone,
                          @"old_password":userModel.password,
                          @"new_password":userModel.nPassword,
                          @"home_address":homeAdress.formatted_address,
                          @"home_address_lat":[NSString stringWithFormat:@"%f", homeAdress.location.latitude],
                          @"home_address_lon":[NSString stringWithFormat:@"%f", homeAdress.location.longitude],
                          @"work_address":workAdress.formatted_address,
                          @"work_address_lat":[NSString stringWithFormat:@"%f", workAdress.location.latitude],
                          @"work_address_lon":[NSString stringWithFormat:@"%f", workAdress.location.longitude]};
        }
        else
        {
            if (homeAdress && homeAdress != NULL)
            {
                if (userModel.password.length == 0 || userModel.nPassword.length == 0)
                    param = @{@"name":userModel.name,
                              @"phone":userModel.phone,
                              @"home_address":homeAdress.formatted_address,
                              @"home_address_lat":[NSString stringWithFormat:@"%f", homeAdress.location.latitude],
                              @"home_address_lon":[NSString stringWithFormat:@"%f", homeAdress.location.longitude]};
                else
                    param = @{@"name":userModel.name,
                              @"phone":userModel.phone,
                              @"old_password":userModel.password,
                              @"new_password":userModel.nPassword,
                              @"home_address":homeAdress.formatted_address,
                              @"home_address_lat":[NSString stringWithFormat:@"%f", homeAdress.location.latitude],
                              @"home_address_lon":[NSString stringWithFormat:@"%f", homeAdress.location.longitude]};
            }
            else if (workAdress && workAdress != NULL)
            {
                if (userModel.password.length == 0 || userModel.nPassword.length == 0)
                    param = @{@"name":userModel.name,
                              @"phone":userModel.phone,
                              @"work_address":workAdress.formatted_address,
                              @"work_address_lat":[NSString stringWithFormat:@"%f", workAdress.location.latitude],
                              @"work_address_lon":[NSString stringWithFormat:@"%f", workAdress.location.longitude]};
                else
                    param = @{@"name":userModel.name,
                              @"phone":userModel.phone,
                              @"old_password":userModel.password,
                              @"new_password":userModel.nPassword,
                              @"work_address":workAdress.formatted_address,
                              @"work_address_lat":[NSString stringWithFormat:@"%f", workAdress.location.latitude],
                              @"work_address_lon":[NSString stringWithFormat:@"%f", workAdress.location.longitude]};
            }
            else
            {
                if (userModel.password.length == 0 || userModel.nPassword.length == 0)
                    if (userModel.isFB)
                        param = @{@"name":userModel.name,
                                  @"phone":userModel.phone,
                                  @"social":userModel.socialId};
                    else
                        param = @{@"name":userModel.name,
                                  @"phone":userModel.phone};
                
                
                    else
                        if (userModel.isFB)
                            param = @{@"name":userModel.name,
                                      @"phone":userModel.phone,
                                      @"social":userModel.socialId,
                                      @"old_password":userModel.password,
                                      @"new_password":userModel.nPassword};
                        else
                            param = @{@"name":userModel.name,
                                      @"phone":userModel.phone,
                                      @"old_password":userModel.password,
                                      @"new_password":userModel.nPassword};
                
            }
        }
    }
    @catch (NSException *exception) { STLogException(exception); }
    
    NSString *method = [NSString stringWithFormat:@"profile/update"];
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        
        ResponseModel *response = [[ResponseModel alloc] initWithResponseData:responseObject];
        
        if (operation.response.statusCode == 200 ||
            operation.response.statusCode == 201)
        {
            NSString *token = responseObject[@"token"];
            [[Settings instance] setToken:token];
            
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            PlaceModel *workModel = [[PlaceModel alloc] initWithWorkDictionary:responseObject];
            PlaceModel *homeModel = [[PlaceModel alloc] initWithHomeDictionary:responseObject];
            
            [[Settings instance] setHomeAddress:homeModel];
            [[Settings instance] setWorkAddress:workModel];
            
            if (success) success(userModel);
        }
        else
            if (failure) failure(nil, response.code);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        ResponseModel *response = [[ResponseModel alloc] initWithResponseData:operation.responseData];
        @try { failure (error, response.code); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

//#pragma mark - Courier
//#pragma mark - Track Order
//
//- (void) trackingOrder:(OrderModel *)order
//               success:(void (^)(void))success
//               failure:(void (^)(NSError *error, NSInteger code))failure {
//    
//    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
//    param[@"location"]          = NIL_TO_NULL(order.hashCurrentLocationAddress);
//    param[@"address"]           = NIL_TO_NULL(order.currentAddress);
//    param[@"longitude"]         = [NSString stringWithFormat:@"%f", order.packageLocation.longitude];
//    param[@"latitude"]          = [NSString stringWithFormat:@"%f", order.packageLocation.latitude];
//    
//    NSString *method = [NSString stringWithFormat:@"track"];
//    PRTParameters(param, URLMethod(method));
//    
//    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
//    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    } success:^(AFHTTPRequestOperation *operation, id responseObject)  {
//        PRTSuccessOperation(operation);
//        @try { success();}
//        @catch (NSException *exception) { STLogException(exception); }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        PRTFailureOperation(operation);
//        @try { failure (error, operation.response.statusCode); }
//        @catch (NSException *exception) { STLogException(exception); }
//    }];
//}

#pragma mark - UpdateOrder

- (void) updateOrder:(OrderModel *)order
          withStatus:(OrderStatus)status
             success:(void (^)(void))success
             failure:(void (^)(NSError *error, NSInteger code))failure {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"stage"] = NIL_TO_NULL([self orderStageNameFromStatus:status]);
    
    NSString *method = [NSString stringWithFormat:@"order/update/%@",STRING(order._id)];
    STLogDebug(@"909090909090");
    STLogDebug(@"OrderModel status: %zd",order.orderStatus);
    STLogDebug(@"selected status: %zd",status);
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        PRTSuccessOperation(operation);
        [self viewOrder:order success:^{
            STLogDebug(@"Updated order: %@", order);
            if (success) {
                success();
            }
            
        } failure:^(NSError *error, NSInteger code) {
            if (failure) failure(error, code);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        if (failure) failure(error, operation.response.statusCode);
    }];
}

- (void)viewOrder:(OrderModel *)order
          success:(void (^)(void))success
          failure:(void (^)(NSError *error, NSInteger code))failure {
    
    NSString *method = [NSString stringWithFormat:@"order/view/%@",STRING(order._id)];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (IS_COURIER_APP) {
        CLLocation *currentLocation = [[AppDelegate instance] currentLocation];
        param[@"longitude"] = [NSString stringWithFormat:@"%.5f",currentLocation.coordinate.longitude];
        param[@"latitude"] = [NSString stringWithFormat:@"%.5f",currentLocation.coordinate.latitude];
    }
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:URLMethod(method) parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        
        [order mappingDictionary:responseObject];
        if (success) {
            success();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

- (NSString *)orderStageNameFromStatus:(OrderStatus)status {
    switch (status) {
        case OrderStatusAccept:     return @"accept";
        case OrderStatusPickUp:     return @"pick_up";
        case OrderStatusProgress:   return @"progress";
        case OrderStatusDelivery:   return @"delivery";
        case OrderStatusClose:      return @"close";
        default:                    return @"";
    }
}

#pragma mark - Statistics

- (void)statisticsByRange:(StatisticRange)range
                  success:(void (^)(StatisticModel *statistic))success
                  failure:(void (^)(NSError *error, NSInteger code))failure {
    
    NSString *method = [NSString stringWithFormat:@"statistic/all"];
    PRTParameters(nil, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:URLMethod(method) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        
        __block StatisticModel *stat = [StatisticModel new];
        stat.statisticRange = range;
        [stat mappingAllStatisticDictionary:responseObject];
        
        /* Select/configure statistics by range */
        NSString *method = [NSString stringWithFormat:@"statistic/%@", stat.statisticRangeName];
        PRTParameters(nil, URLMethod(method));
        
        [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
        [REQUEST GET:URLMethod(method) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            PRTSuccessOperation(operation);
            [stat mappingStatisticByRange:range withDictionary:responseObject];
            
            if (success) success(stat);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            PRTFailureOperation(operation);
            @try { failure (error, operation.response.statusCode); }
            @catch (NSException *exception) { STLogException(exception); }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

- (void)rateCourier:(NSString *)courier
        withRaiting:(NSNumber *)rating
            success:(void (^)(void))success
            failure:(void (^)(NSError *, NSInteger))failure
{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    param[@"rate"]              = NIL_TO_NULL(rating);
    param[@"courier"]           = NIL_TO_NULL(courier);
    
    NSString *method = [NSString stringWithFormat:@"rate"];
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        PRTSuccessOperation(operation);
        @try { success();}
        @catch (NSException *exception) { STLogException(exception); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

#pragma mark - Check in Database

- (void)checkSocialId:(id)socialId
              success:(void (^)(BOOL hasSocialId))success
              failure:(void (^)(NSError *error, NSInteger code))failure {
    
    NSString *method = @"check";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = NIL_TO_NULL(socialId);
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:URLMethod(method) parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        if (success) success(YES);

    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        PRTFailureOperation(operation);
        if (operation.response.statusCode == 409) {
            if (success) success(NO);
        } else {
            if (failure) failure(error, operation.response.statusCode);
        }
    }];
}

- (void)supportPhoneSuccess:(void (^)(NSString *phoneNumber))success
                    failure:(void (^)(NSError *error, NSInteger code))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *method = [NSString stringWithFormat:@"support"];
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:URLMethod(method) parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        NSString *phoneNumber = responseObject[@"support_number"];
        if (success) success(phoneNumber);
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

- (void)clearBadgesSuccess:(void (^)(void))success
                   failure:(void (^)(NSError *error, NSInteger code))failure
{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    NSString *method = [NSString stringWithFormat:@"profile/badge"];
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        PRTSuccessOperation(operation);
        @try { success();}
        @catch (NSException *exception) { STLogException(exception); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

#pragma mark - Restore password

- (void)updatePassword:(NSString *)psw
        forPhoneNumber:(NSString *)phoneNumber
               success:(void (^)(void))success
               failure:(void (^)(NSError *error, NSInteger code))failure {

    STLogMethod;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = NIL_TO_NULL([phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]);
    param[@"password"] = NIL_TO_NULL(psw);
    
    NSString *method = [NSString stringWithFormat:@"recovery"];
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        PRTSuccessOperation(operation);
        @try { success();}
        @catch (NSException *exception) { STLogException(exception); }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}


#pragma mark - uploadImage (/client/profile/logo)
#pragma mark -


- (void) uploadImageFromPath:(NSString *) path
                success:(void (^)(UserModel *userModel))success
                failure:(void (^)(NSError *error, NSInteger code))failure {
    
    NSURL *url      = [NSURL URLWithString:path];
    NSData *data    = [NSData dataWithContentsOfURL:url];
    UIImage *img    = [[UIImage alloc] initWithData:data];

    [self uploadImage:img success:^(UserModel *userModel) {
        if (success) {
            success(userModel);
        }
    } failure:^(NSError *error, NSInteger code) {
        @try { failure (error, code); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

- (void)uploadImage:(UIImage *)image
             success:(void (^)(UserModel *userModel))success
             failure:(void (^)(NSError *error, NSInteger code))failure
{
    NSString *method = @"profile/logo";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    PRTParameters(param, URLMethod(method));
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST POST:URLMethod(method) parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImagePNGRepresentation(image);
        if (imageData)
        {
            //[formData appendPartWithHeaders:@{@"Content-Type":@"image/jpeg"} body:imageData];
            [formData appendPartWithFileData:imageData name:@"logo" fileName:@"image.png" mimeType:@"image/png"];
        }
        STLogSuccess(@"profile/logo data: %@",formData);
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PRTSuccessOperation(operation);
        
        if (success) {
            UserModel *userModel = [[UserModel alloc] initWithDictionary:responseObject];
            success(userModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PRTFailureOperation(operation);
        @try { failure (error, operation.response.statusCode); }
        @catch (NSException *exception) { STLogException(exception); }
    }];
}

//https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters

#pragma mark - searchPlace (maps.googleapis.com/maps/api/place/textsearch/json)
#pragma mark -

- (void)GMSSearchPlace:(NSString *)address
               success:(void (^)(NSArray *placesArray))success
               failure:(void (^)(NSError *error, NSInteger code))failure
{
//    NSNumber *radius = @16000; // Длина города одессы 32 км
//    NSString *loc = @"46.474547, 30.709376"; //odessa
    //adress = [NSString stringWithFormat:@"street=Govorova"];

    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    
//    //25.388982, 55.510278
//    //24.995920, 55.057638
//    // Dubai
//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(@(25.388982).doubleValue, @(55.510278).doubleValue);
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(@(24.995920).doubleValue, @(55.057638).doubleValue);
//
//#ifdef DEBUG
//    // Odessa
//    northEast = CLLocationCoordinate2DMake(@(46.595426).doubleValue, @(30.895268).doubleValue);
//    southWest = CLLocationCoordinate2DMake(@(46.368367).doubleValue, @(30.610116).doubleValue);
//#endif
    
    double radius = 200; //km

    CLLocation *currentLocation = [[AppDelegate instance] currentLocation];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, radius, radius);
//    MKCoordinateSpan tempSpan = region.span;

    
    CLLocationCoordinate2D cc0 = currentLocation.coordinate;
    CLLocationCoordinate2D northEast = [self coordinateFromCoord:cc0 atDistanceKm:radius atBearingDegrees:45];
    CLLocationCoordinate2D southWest = [self coordinateFromCoord:cc0 atDistanceKm:radius atBearingDegrees:225];
    
    NSLog(@"current - %.5f,%.5f -> northEast - %.5f,%.5f AND southWest - %.5f, %.5f", cc0.latitude, cc0.longitude, northEast.latitude, northEast.longitude, southWest.latitude, southWest.longitude);

    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                       coordinate:southWest];
//
//    NSLog(@"GMSCoordinateBounds - %@", bounds);
    
    
    //NSString *searchString = [NSString stringWithFormat:@"Ukraine, Odessa, %@", address];
     NSString *searchString = [NSString stringWithFormat:@"%@", address];
    
    [[GMSPlacesClient sharedClient] autocompleteQuery:searchString
                                               bounds:bounds
                                               filter:filter
                                             callback:^(NSArray *results, NSError *error) {
                                                 if (error != nil) {
                                                     NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                                     return;
                                                 }
                                                 
                                                 //NSLog(@"Autocomplete OK (%@) \n%@",searchString, results);
                                                 
                                                 NSMutableArray *placesArray = [NSMutableArray array];
                                                 for (GMSAutocompletePrediction* result in results) {
                                                     
                                                     PlaceModel *palceModel = [[PlaceModel alloc] initWithGMSAutocompletePrediction:result];
                                                     [placesArray addObject:palceModel];
                                                     
                                                     NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                                 }
                                                 if (success) success(placesArray);
                                                 
                                             }];
}

- (void)GMSUpdatePlace:(PlaceModel *)place
               success:(void (^)(void))success
               failure:(void (^)(NSError *error, NSInteger code))failure
{
    STLogMethod;
    [[GMSPlacesClient sharedClient] lookUpPlaceID:STRING(place.place_id) callback:^(GMSPlace *result, NSError *error) {
        STLogDebug(@"STRING(place.place_id): %@",STRING(place.place_id));
        if (error) {
            NSLog(@"Update place error %@", [error localizedDescription]);
            if (failure) failure(error, error.code);
        
        } else {
            [place updateWithGMSPlace:result];
            if (success) success();
        }
    }];
}

- (void)GMSCurrentPlaceSuccess:(void (^)(NSArray *places))success
                       failure:(void (^)(NSError *error, NSInteger code))failure {

    STLogMethod;
    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error) {
            if (failure) {
                failure(error, error.code);
            }
        
        } else {
            GMSPlaceLikelihood *placeLikelihood = likelihoodList.likelihoods.firstObject;
            GMSPlace *place = placeLikelihood.place;
            
            PlaceModel *placeModel = [PlaceModel new];
            [placeModel updateWithGMSPlace:place];
        
            STLogDebug(@"name: %@",placeModel.name);
            STLogDebug(@"formattedAddress: %@",placeModel.formatted_address);
            
            if (success) {
                success(@[placeModel]);
            }
        }
    }];
}

#pragma mark - POST methods

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[Constants baseURL]]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //_manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        //_manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //_manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"application/json"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        _manager.responseSerializer = jsonResponseSerializer;
    }
    
    return _manager;
}

- (void)clearOperations {
    STLogMethod;
    [[self.manager operationQueue] cancelAllOperations];
}

#pragma mark - Printing

void PRTParameters(NSDictionary *param, NSString *url) {
    STLog(@"PARAM %@\n%@",
          url,
          param);
}

void PRTSuccessOperation(AFHTTPRequestOperation *operation) {
    STLog(@"RESPONSE Success [%zd], %@\n%@",
          operation.response.statusCode,
          operation.response.URL.absoluteString,
          operation.responseObject);
}

void PRTFailureOperation(AFHTTPRequestOperation *operation) {
    STLog(@"RESPONSE Failure [%zd], %@\n%@",
          operation.response.statusCode,
          operation.response.URL.absoluteString,
          operation.responseObject);
}

#pragma mark - Calculation Search radius

- (double)radiansFromDegrees:(double)degrees {
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians {
    return radians * (180.0/M_PI);
}

- (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distanceKm / 6371.0; //km
    //6371km = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return result;
}


@end
