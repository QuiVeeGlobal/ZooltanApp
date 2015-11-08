//
//  Analytics.h
//  Experts
//
//  Created by Eugene Vegner on 21.10.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GAI.h"
//#import "Flurry.h"

#import "GAITracker.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"

//@class GameModel;

@interface Analytics : NSObject

+ (instancetype)instance;

- (void)startGAI;

//- (void)startFlurry;

// Flurry
//- (void)flurryLogScreenName:(NSString *)screenName;

// General
//- (void)logUserLevel:(NSNumber *)level
//      withCategoryId:(NSNumber *)categoryId
//     andCategoryName:(NSString *)categoryName;
//
//- (void)logUserData:(UserModel *)userModel;
//- (void)logInviteAtSocialType:(SocialType)socialType;
//- (void)logNumberOfDays;
//- (void)logFinishGame:(GameModel*)game DEPRECATED_IN_VERSION_1_1_0_AND_LATER;
//- (void)logStartSession;
//- (void)logEndSession;

@end
