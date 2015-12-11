//
//  SocialModelController.h
//  PhotoSmileys
//
//  Created by Grigoriy on 8/12/13.
//  Copyright (c) 2013 ITSumma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccount.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserModel.h"


#define kNotificationFBFriendInvited @"notificationFBFriendInvited"

@class Settings;

@interface SocialManager : NSObject
@property (nonatomic, strong) Settings *settings;

+ (SocialManager*) instance;

//FB

- (void) autoriseInFBAndGetUseDataWithSuccess:(void (^)(UserModel *userModel))success
                                      failure:(void (^)(NSError *error, NSString *status))failure;


//- (void) autoriseInFBAndGetFiendsTarget:(id) target success:(SEL) success fail:(SEL) fail;
//- (void) autoriseInFBAndGetFiendsWithInviteMessage:(NSString *) inviteMessage target:(id) target success:(SEL) success fail:(SEL) fail;
//- (void) autoriseInFBAndGetUserId:(id) target success:(SEL) success fail:(SEL) fail;
//- (void) autoriseInFBAndGetAccessToken:(id)target success:(SEL)success fail:(SEL)fail;
//
//- (void) publishByFAcebook:(NSString *) message
//               description:(NSString *) description
//                 friendsId:(NSArray *) suggestedFriends
//                image_path:(NSString *) image_path
//                 isPicture:(BOOL) isPicture
//                    target:(id) target
//                   success:(SEL) success
//                      fail:(SEL) fail;

@end
