//
//  Constants.h
//  Experts
//
//  Created by Eugene on 12.05.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kFacebookAppId              @"958468550863646"
#define googlURL                    @"https://maps.googleapis.com/maps/api/"
#define googlAPIKey                 @"AIzaSyCrFx2QMIXOCeN5jtA6SqjmKqy99JlhYl0"
#define browserGooglAPIKey          @"AIzaSyBNlbUrNtAy5GNSIG--Oo_kPuWAPOK7sNw"

#define kNotificationOpenSearch     @"kNotificationOpenSearch"
#define kNotificationOpenProfile    @"kNotificationOpenProfile"
#define kNotificationTrackLocation  @"kNotificationTrackLocation"

#define kAnswersCount 4
#define kViewCornerRadius 8.0f
#define kMaxQuestionTime 10 //Кол-во запросов на ожидания соперника
//#define kOverTimeAsk 10
#define kRequestTimeOut 12

// Дата старта рейтинга на аппсторе 2015-02
#define kStartRatingYear 2015
#define kStartRatingMonth 2

#define kGeneralDateFormat      @"yyyy-MM-ddHH:mm:ss ZZZ"

#define kBirthDateKonvertFormat @"dd-MM-yyyy"
#define kBirthDateVkFormat      @"dd.MM.yyyy"
#define kBirthDateFormat        @"yyyy-MM-dd"
#define kYearAndMonthFormat     @"yyyy-MM"
#define kEmptyDate              @"0000-00-00"

#define kMinutesFormat @"mm"
#define kHoursFormat   @"HH"
#define kDayFormat     @"dd"
#define kMonthFormat   @"MM"
#define kYearFormat    @"yyyy"

//Durations
#define kSystemPingDuration   2
#define kServerTimeOut        20
#define kMaxQuestionImageSize 2000000
#define kDefaultAvatarName    @"dummyAvatar"
#define kAppStoreLink         @"https://itunes.apple.com/us/app/viktorina-znatoki-igraj-s/id933206520?l=ru&ls=1&mt=8"

//#define newCategoryies      @"eXwhqVTbieA4t6qZA9eqg3zaq6EH4qYmwRqvVXjqmhZdqeYloepsrFq"
//#define popularCategoryes   @"P5MHq13KyqdRile1SGje6kfBqSJOVqnVpdqEFrLqjojoe"
//#define favoriteCategoryes  @"sy32q7GTXqQVJcqK2a6qBDGHql8oeeEVvdeOYgQqUFELq8Lghqf1ysqfAZfq"
//#define latestCategoryes    @"YVIjq5M6dqP7gleBo4keipbDq48yhes7jpq5hnoqFfLDq4ccdqmcWGqsaGoeen9te"

//1.2.0
#define kHockeyAppKey       @"f4a7c349d5be16555dd29402e7a416b4"

//Analitics ids (Tester)
//#define kFlurryKey @"PYWDCH8DM3V5KV4SPSC7"
//#define kGAIKey @"UA-55331000-2"

//// TL2
#define kFlurryKey          @"GMHXXPS55PMCBCH4KDK5"
#define kGAIKey             @"UA-974564-9"

// My GA
//#define kFlurryKey @"PYWDCH8DM3V5KV4SPSC7"
//#define kGAIKey @"UA-53978140-1"

// Production
//#define kFlurryKey @"QM3BZ2G2RJKSPGDF2BXR"
//#define kGAIKey @"UA-55331000-3"

// InApp
#define kInAppSharedKey     @""

#define kPhoneCodePrefix    [Constants phoneCodePrefix]
#define kMinCharactersLength 3

@interface Constants : NSObject
+ (NSString *)baseURL;

+ (NSString *)currentStoryboardName;
+ (NSString *)officeCallNumber;
+ (NSString *)hockeyApiKey;
+ (NSString *)GMSApiKey;
+ (NSString *)browserGMSApiKey;
+ (NSString *)GAIKey;

// Check Mobi
+ (NSString *)checkMobiBaseUrl;
+ (NSString *)checkMobiSecretKey;
+ (NSString *)checkMobiSMSLang;
+ (NSString *)checkMobiIvrLang;

// Lean Testing
+ (NSString *)leanTestingKey;
+ (NSString *)leanTestingId;

// Phone
+ (NSString *)phoneCodePrefix;


@end
