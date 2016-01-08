//
//  Settings.h
//  Experts
//
//  Created by Eugene Vegner on 04.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface Settings : NSObject


@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *tokenHash;

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *expertId;
@property (nonatomic, strong) NSDate *installDate;

@property (nonatomic, strong) UserModel *currentUser;
@property (nonatomic, strong) PlaceModel *homeAddress;
@property (nonatomic, strong) PlaceModel *workAddress;
@property (nonatomic, strong) PlaceModel *fromAddress;
@property (nonatomic, strong) PlaceModel *toAddress;
@property (nonatomic, strong) PlaceModel *destinationAddress;

@property (nonatomic, strong) NSArray *questionsIDs;
@property (nonatomic, strong) NSString *gameHash;
@property (nonatomic, assign) BOOL hideSocialViewInFriends;
@property (nonatomic, assign) BOOL appRated;
@property (nonatomic, assign) BOOL rateShowed;

@property (nonatomic, strong) NSNumber *rateCounter;
@property (nonatomic, strong) NSNumber *receivingCoinsMessageCounter;

@property (nonatomic, strong) NSArray *userAwardsTypes;

@property (nonatomic, strong) NSString *systemVersion;
@property (nonatomic, strong) NSString *deviceId;


// New Api V2
@property (nonatomic, strong) NSNumber *pingId;

+ (Settings *) instance;

@end
