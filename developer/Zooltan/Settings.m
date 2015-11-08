//
//  Settings.m
//  Experts
//
//  Created by Eugene Vegner on 04.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import "Settings.h"

#define kUserDefaults [NSUserDefaults standardUserDefaults]

@implementation Settings
@synthesize token = _token;
@synthesize tokenHash = _tokenHash;
@synthesize password = _password;
@synthesize level = _level;
@synthesize expertId = _expertId;
@synthesize installDate = _installDate;
//@synthesize currentUser = _currentUser;
@synthesize gameHash = _gameHash;
@synthesize hideSocialViewInFriends = _hideSocialViewInFriends;
@synthesize userAwardsTypes = _userAwardsTypes;

@synthesize pingId = _pingId;
@synthesize deviceId = _deviceId;


+ (Settings *) instance
{
    static Settings *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Settings alloc] init];
    });
    return instance;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:[self baseURLV2]];
}


- (NSString *)baseURLV2 {
    //return @"http://1stborn.znatokionline.com/api";
    //return @"http://stage.znatokionline.com/api";
    
    return @"http://beta.znatokionline.com/api";
}

- (NSString *)appStoreID {
    return @"id933206520";
}

- (NSString *)VKRedirectURI {
    //oauth2
    return [NSString stringWithFormat:@"%@/oauth2",self.baseURL];

}

- (void)setExpertId:(NSNumber *)expertId {
    _expertId = expertId;
    [kUserDefaults setObject:_expertId forKey:@"settings_user_expertId"];
    [kUserDefaults synchronize];
}

- (NSNumber *)expertId {
    _expertId = [kUserDefaults objectForKey:@"settings_user_expertId"];
    if (!_expertId) {
        _expertId = @0;
    }
    return _expertId;
}

#pragma mark - Internal settings

- (void)canPlaySoundForLevel {}


#pragma mark - Token
#pragma mark -

- (void)setToken:(NSString *)token
{
    NSLog(@"setToken %@", token);
    
    if (token)
    {
        _token = token;
        [kUserDefaults setObject:_token forKey:@"settings.token"];
        [kUserDefaults synchronize];
    }
}

- (NSString *)token
{
    NSString *useDEf = [kUserDefaults objectForKey:@"settings.token"];
    
    NSLog(@"getToken %@", useDEf);
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    return useDEf;
}

- (void)setTokenHash:(NSString *)tokenHash
{
    if (tokenHash)
    {
        _tokenHash = tokenHash;
        [kUserDefaults setObject:_tokenHash forKey:@"settings.tokenHash"];
        [kUserDefaults synchronize];
    }
}

- (NSString *)tokenHash
{
    _tokenHash = [kUserDefaults objectForKey:@"settings.tokenHash"];
    return _tokenHash;
}


#pragma mark - Password
#pragma mark -

- (void)setPassword:(NSString *)password
{
    if (password)
    {
        _password = password;
        [kUserDefaults setObject:_password forKey:@"settings.password"];
        [kUserDefaults synchronize];
    }
}

- (NSString *)password
{
    return [kUserDefaults objectForKey:@"settings.password"];
}

#pragma mark - UserModel

- (void)setCurrentUser:(UserModel *)currentUser
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [kUserDefaults setObject:data forKey:@"settings_user"];
    [kUserDefaults synchronize];
}

- (UserModel *)currentUser
{
    NSData *data = [kUserDefaults objectForKey:@"settings_user"];
    UserModel *_userModel = (data) ? (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data] : [[UserModel alloc] init];
    //STLogInfo(@"CURRENT USER: %@",_userModel);
    return _userModel;
}

#pragma mark - homeAddress

- (void)setHomeAddress:(PlaceModel *)homeAddress
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:homeAddress];
    [kUserDefaults setObject:data forKey:@"settings_homeAddress"];
    [kUserDefaults synchronize];
}

- (PlaceModel *) homeAddress
{
    NSData *data = [kUserDefaults objectForKey:@"settings_homeAddress"];
    PlaceModel *homeAddress = (data) ? (PlaceModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data] : [[PlaceModel alloc] init];
    //STLogInfo(@"CURRENT USER: %@",_userModel);
    return homeAddress;
}

#pragma mark - workAddress

- (void)setWorkAddress:(PlaceModel *)workAddress
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:workAddress];
    [kUserDefaults setObject:data forKey:@"settings_workAddress"];
    [kUserDefaults synchronize];
}

- (PlaceModel *)workAddress
{
    NSData *data = [kUserDefaults objectForKey:@"settings_workAddress"];
    PlaceModel *placeModel = (data) ? (PlaceModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data] : [[PlaceModel alloc] init];
    //STLogInfo(@"CURRENT USER: %@",_userModel);
    return placeModel;
}

#pragma mark - fromAddress

- (void)setFromAddress:(PlaceModel *)fromAddress
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:fromAddress];
    [kUserDefaults setObject:data forKey:@"settings_fromAddress"];
    [kUserDefaults synchronize];
}

- (PlaceModel *)fromAddress
{
    NSData *data = [kUserDefaults objectForKey:@"settings_fromAddress"];
    PlaceModel *placeModel = (data) ? (PlaceModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data] : [[PlaceModel alloc] init];
    //STLogInfo(@"CURRENT USER: %@",_userModel);
    return placeModel;
}

#pragma mark - toAddress

- (void)setToAddress:(PlaceModel *)toAddress
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:toAddress];
    [kUserDefaults setObject:data forKey:@"settings_toAddress"];
    [kUserDefaults synchronize];
}

- (PlaceModel *)toAddress
{
    NSData *data = [kUserDefaults objectForKey:@"settings_toAddress"];
    PlaceModel *placeMadel = (data) ? (PlaceModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data] : [[PlaceModel alloc] init];
    
    return placeMadel;
}

#pragma mark - destiantionAddress

- (void)setDestinationAddress:(PlaceModel *)destinationAddress
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:destinationAddress];
    [kUserDefaults setObject:data forKey:@"settings_destinationAddress"];
    [kUserDefaults synchronize];
}

- (PlaceModel *)destinationAddress
{
    NSData *data = [kUserDefaults objectForKey:@"settings_destinationAddress"];
    PlaceModel *placeModel = (data) ? (PlaceModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data] : [[PlaceModel alloc] init];
    
    return placeModel;
}

#pragma mark - Install Date
#pragma mark -


- (NSDate *)installDate
{
    STLogMethod;
    NSNumber *numberDate = [kUserDefaults objectForKey:@"settings.installDate"];
    if (!numberDate || [numberDate integerValue] <= 0)
        return [NSDate date];
    else
        return [NSDate dateWithTimeIntervalSince1970:numberDate.integerValue];
}

- (void)setInstallDate:(NSDate *)installDate
{    
    STLogMethod;
    
    if (installDate) {
        //NSDate *date = [self installDate];
        NSNumber *numberDate = [kUserDefaults objectForKey:@"settings.installDate"];
        if (!numberDate || [numberDate integerValue] <= 0)
        {
            NSNumber *numberDate = @([installDate timeIntervalSince1970]);
            [kUserDefaults setObject:numberDate forKey:@"settings.installDate"];
            [kUserDefaults synchronize];
        }
    }
}

#pragma mark - Rate

- (void)didLaunch {
    //Configure rate counter
    NSInteger ratecounter = self.rateCounter.integerValue;
    ratecounter ++;
    self.rateCounter = @(ratecounter);
    self.rateShowed = NO;
}

- (BOOL)needAppRate {
    /* BugFix #170
     Всем игрокам, которые не оценили приложение требуется внутри приложения показывать стандартное окно каждые 10 запусков приложения, начиная с 5-го запуска на главном экране приложения.
     Игрокам оценившим приложение данное окно не показывается.
     */
    
    if (!self.appRated && !self.rateShowed) {
        
        if (self.rateCounter.integerValue == 5) {
            return YES;
        }
        return NO;
    }
    return NO;
}


@end
