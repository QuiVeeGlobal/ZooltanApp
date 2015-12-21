//
//  SocialModelController.m
//  PhotoSmileys
//
//  Created by Grigoriy on 8/12/13.
//  Copyright (c) 2013 ITSumma. All rights reserved.
//

#import "SocialManager.h"
#import "Settings.h"
#import "UserModel.h"

@interface SocialManager () {
    
    UIViewController *vkController;
    UIViewController *mainView;
    
    BOOL vkMess;
    BOOL okMess;
    BOOL getFriends;
    
    BOOL postPictureVK;
    
    id _target;
    
    SEL _fail;
    SEL _success;
    
    NSString *_messageVK;
    NSString *vkfriendId;
    
    NSString *inviteMessageFB;
    
    UIImage *imageVK;
    
    UserModel *_userModel;
}

@end

@implementation SocialManager

+ (SocialManager*) instance {
    static SocialManager* instance = nil;
    
    if (!instance) {
        instance = [[SocialManager alloc] init];
        instance.settings = [Settings new];
    }
    
    return instance;
}

#pragma mark - FaceboookDelegate
#pragma mark -

- (void) autoriseInFBAndGetUseDataWithSuccess:(void (^)(UserModel *userModel))success
                                      failure:(void (^)(NSError *error, NSString *status))failure
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
             failure(error, @"error");
         else if (result.isCancelled)
             failure(error, @"isCancelled");
         else
         {
             if ([FBSDKAccessToken currentAccessToken])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     NSLog(@"result %@", result);
                     
                     if (!error)
                     {
                         NSLog(@"result %@", result);
                         
                         NSDictionary *userData = (NSDictionary *)result;
                         NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
                         
                         UserModel *userModel = [[UserModel alloc] init];
                         userModel.avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
                         userModel.socialId = [NSString stringWithFormat:@"%@", userData[@"id"]];
                         userModel.name = userData[@"name"];
                         userModel.deviceId = deviceId;
                         
                         success(userModel);
                     }
                     else
                         failure(error, @"error");
                 }];
             }
             else
                 failure(error, @"NoAccessToken");
         }
     }];
}


//- (void)autoriseInFBAndGetAccessToken:(id)target success:(SEL)success fail:(SEL)fail
//{
//    STLogMethod;
//    _target = target;
//    _success = success;
//    _fail = fail;
//    inviteMessageFB = @"";
//
//    if (!FBSession.activeSession.isOpen)
//    {
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//            
//            NSLog(@"result %@", result);
//            
//            if (error) {
//                // Process error
//            } else if (result.isCancelled) {
//                // Handle cancellations
//            } else {
//                // If you ask for multiple permissions at once, you
//                // should check if specific permissions missing
//                if ([result.grantedPermissions containsObject:@"email"]) {
//                    // Do work
//                }
//            }
//        }];
//        
//        return;
//        
//        //NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"user_friends", @"email", @"user_birthday",@"offline_access",@"publish_stream",@"user_events",@"read_stream",@"friends_likes", nil];
//        
//        NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"email", nil];//@[@"basic_info, public_profile", @"email", @"user_friends", @"publish_stream"];
//        
//        FBSession *ses = [[FBSession alloc] initWithAppID:kFacebookAppId
//                                              permissions:permissions
//                                          defaultAudience:FBSessionDefaultAudienceOnlyMe
//                                          urlSchemeSuffix:nil
//                                       tokenCacheStrategy:nil];
//
//        [FBSession setActiveSession:ses];
//        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView
//                                completionHandler:^(FBSession *session,
//                                                    FBSessionState state,
//                                                    NSError *error)
//         {
//             if (error) {
//                 [FBSession.activeSession closeAndClearTokenInformation];
//                 FBSession.activeSession = nil;
//                 
//             } else if (session.isOpen)
//                 [self autoriseInFBAndGetAccessToken:target
//                                             success:success
//                                                fail:fail];
//         }];
//        return;
//    }
//    else if (FBSession.activeSession.isOpen)
//    {
//        FBRequest *userRequest = [FBRequest requestForMe];
//        [userRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//            
//            if (error) {
//                STLogError(error);
//                [_target performSelectorOnMainThread:fail
//                                          withObject:error
//                                       waitUntilDone:YES];
//            }
//            else
//            {
//                [FBSession openActiveSessionWithReadPermissions: @[@"public_profile", @"email"]//@[@"basic_info",@"user_groups",@"email"]
//                                                   allowLoginUI:YES
//                                              completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                                  
//                                                  NSDictionary *userInfo = @{@"uid": (user.objectID) ? user.objectID : @"",
//                                                                             @"accessToken": (session.accessTokenData.accessToken) ? session.accessTokenData.accessToken : @""};
//                                                  [_target performSelectorOnMainThread:_success
//                                                                            withObject:userInfo
//                                                                         waitUntilDone:YES];
//
//                                              }];
//            }
//        }];
//    }
//}
//
//- (void) autoriseInFBAndGetFiendsWithInviteMessage:(NSString *) inviteMessage target:(id) target success:(SEL) success fail:(SEL) fail
//{
//    _target = target;
//    _success = success;
//    _fail = fail;
//    
//    inviteMessageFB = inviteMessage;
//    
//    if (!FBSession.activeSession.isOpen)
//    {
//        NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"user_friends", nil];
//        
//        FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
//        [FBSession setActiveSession:session];
//        
//        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView
//                                completionHandler:^(FBSession *session,
//                                                    FBSessionState state,
//                                                    NSError *error) {
//                                    
//                                    if (error) {
//                                        //                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                        //                                                                                            message:error.localizedDescription
//                                        //                                                                                           delegate:nil
//                                        //                                                                                  cancelButtonTitle:@"OK"
//                                        //                                                                                  otherButtonTitles:nil];
//                                        //                                        [alertView show];
//                                        
//                                        [FBSession.activeSession closeAndClearTokenInformation];
//                                        FBSession.activeSession = nil;
//                                        
//                                    } else if (session.isOpen)
//                                        [self autoriseInFBAndGetFiendsWithInviteMessage:inviteMessageFB
//                                                                                 target:target
//                                                                                success:success
//                                                                                   fail:fail];
//                                }];
//        return;
//    }
//    else if (FBSession.activeSession.isOpen)
//    {
//        
//        //        NSDictionary *params = @{@"name" : @"name",
//        //                                 @"caption" : @"caption",
//        //                                 @"description" : @"description",
//        //                                 @"picture" : @"http://www.friendsmash.com/images/logo_large.jpg",
//        //                                 @"link" : @"http://znatokionline.com"};
//        
//        [FBWebDialogs presentRequestsDialogModallyWithSession:nil
//                                                      message:inviteMessageFB
//                                                        title:nil
//                                                   parameters:nil
//                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                          if (error)
//                                                          {
//                                                              STLog(@"Error sending request.");
//                                                              //[_target performSelectorOnMainThread:_fail withObject:@"Error sending request." waitUntilDone:YES];
//                                                          }
//                                                          else
//                                                          {
//                                                              if (result == FBWebDialogResultDialogNotCompleted)
//                                                              {
//                                                                  STLog(@"User canceled request.");
//                                                                  //[_target performSelectorOnMainThread:_fail withObject:@"User canceled request." waitUntilDone:YES];
//                                                              }
//                                                              else
//                                                              {
//                                                                  STLog(@"User completted request.");
//                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                                  
//                                                                  STLog(@"User urlParams: %@",urlParams);
//                                                                  STLog(@"User urlParams: %zd",urlParams.count);
//                                                                  
//                                                                  if (![urlParams valueForKey:@"request"])
//                                                                  {
//                                                                      STLog(@"User canceled request.");
//                                                                      //[_target performSelectorOnMainThread:_fail withObject:@"User canceled request." waitUntilDone:YES];
//                                                                  }
//                                                                  else
//                                                                  {
//                                                                      NSString *requestID = [urlParams valueForKey:@"request"];
//                                                                      STLogInfo(@"Request ID: %@", requestID);
//                                                                      //BugFix #121 Invite sended
//                                                                      //Уведомление об отправки приглашения
//                                                                      //через FB
//                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFBFriendInvited object:nil];
//                                                                      
//                                                                      //[_target performSelectorOnMainThread:_success withObject:urlParams waitUntilDone:YES];
//                                                                  }
//                                                              }
//                                                          }
//                                                      }];
//        
//        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                      NSDictionary* result,
//                                                      NSError *error) {
//            
//            NSArray* friends = [result objectForKey:@"data"];
//            
//            NSMutableArray *_friends = [NSMutableArray array];
//            
//            STLogInfo(@"result %@", result);
//            
//            for (NSDictionary<FBGraphUser>* friend in friends)
//            {
////                FriendModel *friendModel = [[FriendModel alloc] init];
////
////                if (friend.objectID) {
////                    ProviderModel *provider = [ProviderModel new];
////                    [provider setSocialType:SocialTypeFB];
////                    [provider setUid:[NSString stringWithFormat:@"%@",friend.objectID]];
////                    friendModel.providersq = @[provider];
////                }
////
////                friendModel.userName = friend.name;
////                //friendModel.socialId = friend.objectID;
////                friendModel.avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", friend.objectID];
////                
////                [_friends addObject:friendModel];
////                friendModel = nil;
//            }
//            [_target performSelectorOnMainThread:_success withObject:_friends waitUntilDone:YES];
//        }];
//    }
//}
//
//- (void) autoriseInFBAndGetFiendsTarget:(id) target success:(SEL) success fail:(SEL) fail
//{
//    _target = target;
//    _success = success;
//    _fail = fail;
//    
//    inviteMessageFB = @"";
//    
//    if (!FBSession.activeSession.isOpen)
//    {
//        NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"user_friends", nil];
//        
//        FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
//        [FBSession setActiveSession:session];
//        
//        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView
//                                completionHandler:^(FBSession *session,
//                                                    FBSessionState state,
//                                                    NSError *error) {
//                                    
//                                    if (error)
//                                    {
//                                        [FBSession.activeSession closeAndClearTokenInformation];
//                                        FBSession.activeSession = nil;
//                                    }
//                                    else if (session.isOpen)
//                                        [self autoriseInFBAndGetFiendsWithInviteMessage:inviteMessageFB
//                                                                                 target:target
//                                                                                success:success
//                                                                                   fail:fail];
//                                }];
//        return;
//    }
//    else
//    {
//        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                      NSDictionary* result,
//                                                      NSError *error) {
//            
//            NSArray* friends = [result objectForKey:@"data"];
//            
//            NSMutableArray *_friends = [NSMutableArray array];
//            
//            STLogInfo(@"result %@", result);
//            
//            for (NSDictionary<FBGraphUser>* friend in friends)
//            {
////                FriendModel *friendModel = [[FriendModel alloc] init];
////
////                if (friend.objectID) {
////                    ProviderModel *provider = [ProviderModel new];
////                    [provider setSocialType:SocialTypeFB];
////                    [provider setUid:[NSString stringWithFormat:@"%@",friend.objectID]];
////                    friendModel.providersq = @[provider];
////                }
////
////                friendModel.userName = friend.name;
////                //friendModel.socialId = friend.objectID;
////                friendModel.avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", friend.objectID];
////                
////                [_friends addObject:friendModel];
////                friendModel = nil;
//            }
//            [_target performSelectorOnMainThread:_success withObject:_friends waitUntilDone:YES];
//        }];
//    }
//}
//
//- (void) publishByFAcebook:(NSString *) message
//               description:(NSString *) description
//                 friendsId:(NSArray *) suggestedFriends
//                image_path:(NSString *) image_path
//                 isPicture:(BOOL) isPicture
//                    target:(id) target
//                   success:(SEL) success fail:(SEL) fail
//{
//    _target = target;
//    _success = success;
//    _fail = fail;
//    
//    //_userModel = [[DataBase instance] getUserData];
//    //_userModel = self.settings.currentUser;
//    inviteMessageFB = message;
//    
//    [self autoriseWithMassage:message description:description isPicture:isPicture image_path:image_path friendId:suggestedFriends];
//}
//
//- (void) autoriseWithMassage:(NSString *) message
//                 description:(NSString *) description
//                   isPicture:(BOOL) isPicture
//                  image_path:(NSString *) image_path
//                    friendId:(NSArray *) suggestedFriends
//{
//    if (!FBSession.activeSession.isOpen)
//    {
//        NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile", @"user_friends", @"publish_stream", @"publish_actions", nil];
//        
//        FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
//        [FBSession setActiveSession:session];
//        
//        [FBSession.activeSession openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView
//                                completionHandler:^(FBSession *session,
//                                                    FBSessionState state,
//                                                    NSError *error) {
//                                    
//                                    if (error)
//                                    {
//                                        [_target performSelectorOnMainThread:_fail withObject:@"ERROR" waitUntilDone:YES];
//                                        
//                                        [FBSession.activeSession closeAndClearTokenInformation];
//                                        FBSession.activeSession = nil;
//                                        
//                                    }
//                                    else if (session.isOpen)
//                                        [self autoriseWithMassage:message
//                                                      description:description
//                                                        isPicture:isPicture
//                                                       image_path:image_path
//                                                         friendId:suggestedFriends];
//                                    
//                                }];
//        return;
//    }
//    else if (FBSession.activeSession.isOpen)
//    {
//        // Prepare the web dialog parameters
//        NSDictionary *___params = @{@"name" : message,
//                                    @"link" : @"http://znatokionline.com",
//                                    @"caption" : @"http://znatokionline.com",
//                                    @"description" : [NSString stringWithFormat:@"%@ Apple Store %@", description, kAppStoreLink],
//                                    @"picture" : image_path,};
//        
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:___params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      NSLog(@"error %@", error);
//                                                      
//                                                      if (error)
//                                                      {
//                                                          STLogInfo(@"Error publishing story.");
//                                                          [_target performSelectorOnMainThread:_fail withObject:@"Error publishing" waitUntilDone:YES];
//                                                      }
//                                                      else
//                                                      {
//                                                          if (result == FBWebDialogResultDialogNotCompleted)
//                                                          {
//                                                              [_target performSelectorOnMainThread:_fail withObject:@"canceled" waitUntilDone:YES];
//                                                              STLogInfo(@"User canceled story publishing.");
//                                                          }
//                                                          else
//                                                          {
//                                                              if ([[NSString stringWithFormat:@"%@", resultURL] rangeOfString:@"post_id"].location != NSNotFound)
//                                                              {
//                                                                  [_target performSelectorOnMainThread:_success withObject:@"published" waitUntilDone:YES];
//                                                                  STLogInfo(@"Story published.");
//                                                              }
//                                                              else
//                                                              {
//                                                                  [_target performSelectorOnMainThread:_fail withObject:@"canceled" waitUntilDone:YES];
//                                                                  STLogInfo(@"User canceled story publishing.");
//                                                              }
//                                                          }
//                                                      }
//                                                  }];
//    }
//}
//
//- (NSDictionary*)parseURLParams:(NSString *)query {
//    NSArray *pairs = [query componentsSeparatedByString:@"&"];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    for (NSString *pair in pairs)
//    {
//        NSArray *kv = [pair componentsSeparatedByString:@"="];
//        NSString *val =
//        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        params[kv[0]] = val;
//    }
//    return params;
//}
//
//- (NSDate *) dateFromString:(NSString *) date format:(NSString *) format
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    return [formatter dateFromString:date];
//}
//
//- (NSString *) stringFromDate:(NSDate *) date format:(NSString *) format
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    return [formatter stringFromDate:date];
//}
//
//- (NSDate *)correctVkDateString:(NSString *)dateString {
//    if (!dateString || dateString.length < 8) {
//        //8 == 1.1.2000
//        return [NSDate date];
//    }
//    //23.5.1982
//    
//    NSArray *elements = [dateString componentsSeparatedByString:@"."];
//    if (elements.count < 3) {
//        return [NSDate date];
//    }
//    
//    NSString *day = elements[0];
//    NSString *month = elements[1];
//    NSString *year = elements[2];
//    
//    if (day.length < 2) {
//        day = [NSString stringWithFormat:@"0%@",day];
//    }
//    
//    if (month.length < 2) {
//        month = [NSString stringWithFormat:@"0%@",month];
//    }
//    
//    NSString *fullDate = [NSString stringWithFormat:@"%@-%@-%@",day,month,year];
//    return [self dateFromString:fullDate format:kBirthDateKonvertFormat];
//}

@end
