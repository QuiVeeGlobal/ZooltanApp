//
//  Constants.m
//  Experts
//
//  Created by Eugene on 12.05.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (NSString *)baseURL {
    //return @"http://zooltan.rexit.info";
    return @"http://52.24.56.225";
}

+ (NSString *)currentStoryboardName {
    NSString *sb = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIMainStoryboardFile"];
    STLogDebug(@"UIMainStoryboardFile: %@",sb);
    return sb;
}

+ (NSString *)officeCallNumber {
    return @"+380964671857";
}

+ (NSString *)hockeyApiKey {
    if (IS_COURIER_APP) {
        //return @"8df0020bff72de2ee547c97c80a8b0c1";
        return @"9d6db8acb53d4682908f92a973a33026";
    }
    //return @"ccfa87b3f3a288cfb70de72a38aaf54f";
    return @"1e21a20f94a044619e6f6a8c5a9b2579";
}

+ (NSString *)GMSApiKey {
    return @"AIzaSyClHLLZXMOEOYqOkmmvrIzLQIUHWjSYXzQ";
}

+ (NSString *)browserGMSApiKey {
    return @"AIzaSyCZ5M52viG4_-xX-VAbTQnBBT03msCrvds";
}

+ (NSString *)GAIKey {
    if (IS_COURIER_APP) {
        return @"UA-53978140-9";
    }
    return @"UA-53978140-8";
}

#pragma mark - CheckMobi

+ (NSString *)checkMobiBaseUrl {
    return @"https://api.checkmobi.com/v1/";
}

+ (NSString *)checkMobiSecretKey {
    return @"5B62F7C7-B99F-42EC-97A2-95E8C4259D3F";
}

+ (NSString *)checkMobiSMSLang {
    return @"";
}

+ (NSString *)checkMobiIvrLang {
    return @"";
}

#pragma mark - Lean Testing

+ (NSString *)leanTestingKey
{
    if (IS_COURIER_APP) {
        return @"VwTe5LTsExgRVSwsC7VJ431MdIYqjhwuoifVSHjx";
    }
    return @"OXVsxWolpnjvNh4uo874FsMpCkXNJLCB9wP9hNIU";
}

+ (NSString *)leanTestingId
{
    if (IS_COURIER_APP) {
        return @"7610";
    }
    return @"7608";
}

#pragma mark - Phone

+ (NSString *)phoneCodePrefix {
#ifdef DEBUG
    return @"+380";
#endif
    return @"+971";
}

@end
