//
//  Analytics.m
//  Experts
//
//  Created by Eugene Vegner on 21.10.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import "Analytics.h"
#import "GAIDictionaryBuilder.h"

@implementation Analytics
//{
//    Settings *settings;
//}

+ (instancetype)instance {
    static Analytics *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Analytics alloc] init];
    });
    return instance;
}

- (void)startGAI {
//    if (!settings)
//        settings = [[Settings alloc] init];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 10;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    [[GAI sharedInstance] trackerWithTrackingId:[Constants GAIKey]];
    
    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker setAllowIDFACollection:YES];
}

//- (void)startFlurry {
//    [Flurry setCrashReportingEnabled:YES];
//
//    // Set App version to Flurry
//    NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//    STLog(@"APP VERSION: %@", appVersion);
//
//    [Flurry setAppVersion:appVersion];
//    [Flurry startSession:kFlurryKey];
//
//    //[Flurry setEventLoggingEnabled:YES];
//    //[Flurry setBackgroundSessionEnabled:YES];
//}

//#pragma mark - Flurry 
//
//- (void)flurryLogScreenName:(NSString *)screenName {
//    //STLogDebug(@"flurryLogScreenName: %@",screenName);
//    [Flurry logEvent:screenName];
//    //[Flurry logEvent:screenName timed:YES];
//}
//
//#pragma mark - Level Up
//
//- (void)logUserLevel:(NSNumber *)level
//      withCategoryId:(NSNumber *)categoryId
//     andCategoryName:(NSString *)categoryName {
//
//    /*
//    Событие "User Level" так и остается для категории "Эрудиция".
//    Добавить. Событие "MUL" (Main User Level). Данное событие работает по такому же принципу, что и "User Level" только по общему уровню.
//    Добавить. Событие "User Level {Category_Name}". Данное событие работает по такому же принципу, что и "User Level", только с учетом категории.
//    */
//
//    NSString *logEventName;
//
//    switch (categoryId.integerValue) {
//
//        case 0: /*General level*/
//            logEventName = @"MUL";
//            break;
//
//        case 1: /*Для категории "Эрудиция"*/
//            logEventName = @"User Level";
//            break;
//
//        default: /*Для всех остальных категорий*/
//            logEventName = [NSString stringWithFormat:@"User Level %@", categoryName];
//            break;
//    }
//
//    NSString *strLevel = [NSString stringWithFormat:@"%zd", level.integerValue];
//
//    @try {
//        // Flurry
//        
//        [Flurry logEvent:logEventName withParameters:@{@"Level Up" : strLevel}];
//
//        //Google
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        GAIDictionaryBuilder *dic =
//                [GAIDictionaryBuilder createEventWithCategory:logEventName
//                                                       action:[NSString stringWithFormat:@"Level Up (%@)", strLevel]
//                                                        label:@""
//                                                        value:nil];
//        [tracker send:[dic build]];
//
//    }
//    @catch (NSException *exception) {
//        STLogException(exception);
//    }
//}
//
//#pragma mark - send the User Info from social network in the analytics
//
//- (void)logUserData:(UserModel *)userModel {
//
//    STLog(@"PARAMETERS userModel: %@", userModel);
//
//    @try {
//        NSString *socialType = @"email";
//
//        if (userModel.socialType == SocialTypeVK)
//            socialType = @"vk";
//        else if (userModel.socialType == SocialTypeFB)
//            socialType = @"fb";
//
//        Country *country = [[GeoManager instance] currentCountry];
//
////        NSDictionary *param = @{@"userId":userModel.socialId,
////                                @"userName":userModel.userName,
////                                @"socialType":socialType,
////                                @"email":userModel.email,
////                                @"country":country.nameEn};
//
//        NSInteger currentYear = [[self stringFromDate:[NSDate date] format:kYearFormat] integerValue];
//        NSString *birthDateFormat;
//
//        switch (userModel.socialType) {
//            //case SocialTypeVK:
//            case SocialTypeFB:
//                birthDateFormat = kBirthDateKonvertFormat;
//                break;
//
//            default:
//                birthDateFormat = kBirthDateFormat;
//                break;
//        }
//
//        NSDate *birthDate = [self dateFromString:userModel.birthDate format:birthDateFormat];
//        STLog(@"userModel.birthDate: %@", userModel.birthDate);
//        STLog(@"birthDate: %@", birthDate);
//        NSInteger bdYear = [[self stringFromDate:birthDate format:kYearFormat] integerValue];
//
//        STLog(@"currentYear: %zd", currentYear);
//        STLog(@"bdYear: %zd", bdYear);
//
//        NSInteger age = currentYear - bdYear;
//        STLog(@"age: %zd", age);
//
//        if (age >= currentYear)
//            age = 0;
//
//        NSString *email = (userModel.email.length > 0)
//                ? [NSString stringWithFormat:@"%@ (%@)", userModel.email, socialType]
//                : @"";
//
//        ProviderModel *provider = [userModel providerWithSocialType:userModel.socialType];
//
//        NSDictionary *param = @{@"userId" : [NSString stringWithFormat:@"%@", provider.uid],
//                @"userName" : userModel.userName,
//                @"socialType" : socialType,
//                @"email" : email,
//                @"country" : country.name,
//                @"gender" : [NSString stringWithFormat:@"%@", userModel.gender],
//                @"age" : [NSString stringWithFormat:@"%zd", age]};
//
//        STLog(@"PARAMETERS: %@", param);
//
//        // Flurry
//        [Flurry logEvent:@"User Info" withParameters:param];
//        [Flurry setUserID:[NSString stringWithFormat:@"%@", provider.uid]];
//        [Flurry setGender:[NSString stringWithFormat:@"%@", userModel.gender]];
//        [Flurry setAge:(int) age];
//
//        //Google
//        [[[GAI sharedInstance] defaultTracker] set:[GAIFields customDimensionForIndex:1] value:provider.uid];
//        [[[GAI sharedInstance] defaultTracker] set:[GAIFields customDimensionForIndex:2] value:userModel.gender];
//        [[[GAI sharedInstance] defaultTracker] set:[GAIFields customDimensionForIndex:3] value:[NSString stringWithFormat:@"%zd", age]];
//        [[[GAI sharedInstance] defaultTracker] set:[GAIFields customDimensionForIndex:4] value:country.name];
//
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        GAIDictionaryBuilder *dic = [GAIDictionaryBuilder createEventWithCategory:@"User Info"
//                                                                           action:@"get User Info From Social"
//                                                                            label:socialType
//                                                                            value:[NSNumber numberWithInteger:[provider.uid integerValue]]];
//
//        [dic setAll:param];
//        [tracker send:[dic build]];
//
//    }
//    @catch (NSException *exception) {
//        STLogException(exception);
//    }
//}
//
//- (NSDate *)dateFromString:(NSString *)date format:(NSString *)format {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    return [formatter dateFromString:date];
//}
//
//- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    return [formatter stringFromDate:date];
//}
//
//#pragma mark - send the number of days in the analytics
//
//- (void)logNumberOfDays {
//    if (!settings)
//        settings = [[Settings alloc] init];
//
//    NSDate *installDate = [settings installDate];
//    NSDate *today = [NSDate date];
//
//    int secondsBetween = [today timeIntervalSinceDate:installDate];
//    int numberOfDays = secondsBetween / 86400;
//
//    NSString *days = [NSString stringWithFormat:@"%d", numberOfDays];
//
//    @try {
//        // Flurry
//        [Flurry logEvent:@"Days after install" withParameters:@{@"Days" : days}];
//
//        //Google
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        GAIDictionaryBuilder *dic =
//                [GAIDictionaryBuilder createEventWithCategory:@"Days after install"
//                                                       action:[NSString stringWithFormat:@"Days (%@)", days]
//                                                        label:@""
//                                                        value:nil];
//        [tracker send:[dic build]];
//    }
//    @catch (NSException *exception) {STLogException(exception);}
//}
//
//- (void)logInviteAtSocialType:(SocialType)socialType {
//    @try {
//        NSString *socialName = @"fb";
//
//        if (socialType == SocialTypeVK)
//            socialName = @"vk";
//
//        // Flurry
//        NSString *invite = [NSString stringWithFormat:@"Invite friend from %@", socialName];
//        [Flurry logEvent:@"Invite friend" withParameters:@{@"Invite" : invite}];
//
//        //Google
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        GAIDictionaryBuilder *dic = [GAIDictionaryBuilder createEventWithCategory:@"Invites"
//                                                                           action:[NSString stringWithFormat:@"Invite friend from %@", socialName]
//                                                                            label:@""
//                                                                            value:nil];
//        [tracker send:[dic build]];
//
//    }
//    @catch (NSException *exception) {
//        STLogException(exception);
//    }
//}
//
//- (void)logFinishGame:(GameModel *)game {
//
//    if (game.results.count != game.board.questions.count) {
//        return;
//    }
//
//    @try {
//        NSString *event = @"Game Finished";
//
//        // Flurry
//        [Flurry logEvent:event];
//
//        //Google
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        GAIDictionaryBuilder *dic =
//                [GAIDictionaryBuilder createEventWithCategory:@"Game"
//                                                       action:@"Finished"
//                                                        label:@""
//                                                        value:nil];
//        [tracker send:[dic build]];
//    }
//    @catch (NSException *exception) {STLogException(exception);}
//}


// #pragma mark - logStartSession
//
// - (void) logStartSession
// {
//     @try {
//         // Flurry
//         [Flurry logEvent:@"start session"timed:YES];
//
//         //Google
//         id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//         GAIDictionaryBuilder *dic =
//         [GAIDictionaryBuilder createEventWithCategory:@"session"
//                                                action:@"start session"
//                                                 label:[[DataBase instance] dateToNSString:[NSDate date]]
//                                                 value:@(1)];
//         [tracker send:[dic build]];
//     }
//     @catch (NSException *exception) {STLogException(exception);}
// }
//
// #pragma mark - logEndSession
//
// - (void) logEndSession
// {
//     @try {
//         // Flurry
//         [Flurry logEvent:@"end session"timed:YES];
//
//         //Google
//         id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//         GAIDictionaryBuilder *dic =
//         [GAIDictionaryBuilder createEventWithCategory:@"session"
//                                                action:@"end session"
//                                                 label:[[DataBase instance] dateToNSString:[NSDate date]]
//                                                 value:@(1)];
//         [tracker send:[dic build]];
//     }
//     @catch (NSException *exception) {STLogException(exception);}
// }

@end
