

#import "UserModel.h"

#define kSettingsUserId         @"settings.user.id"
#define kSettingsUserAvatarURL  @"settings.user.avatarURL"
#define kSettingsUserName       @"settings.user.name"
#define kSettingsUserPhone      @"settings.user.phone"
#define kSettingsUserSocialId   @"settings.user.social.id"
#define kSettingsUserEmail      @"settings.user.email"
#define kSettingsUserIsOnline   @"settings.user.online"
#define kSettingsUserIsBot      @"settings.user.bot"
#define kSettingsUserGender     @"settings.user.gender"
#define kSettingsUserCountry    @"settings.user.country"
#define kSettingsUserCity       @"settings.user.city"
#define kSettingsUserDesc       @"settings.user.desc"
#define kSettingsUserBirthDate  @"settings.user.birth.date"
#define kSettingsUserAvgScores  @"settings.user.avg.scores"
#define kSettingsUserAvgSpeeds  @"settings.user.avg.speeds"
#define kSettingsUserDeviceId   @"settings.user.device.id"
#define kSettingsUserDraws      @"settings.user.draws"
#define kSettingsUserLevel      @"settings.user.levels"
#define kSettingsUserLosts      @"settings.user.losts"
#define kSettingsUserWins       @"settings.user.wins"
#define kSettingsUserFriendsCount   @"settings.user.friends.count"
#define kSettingsUserAwardsCount    @"settings.user.awards.count"
#define kSettingsUserBlokedFriends  @"settings.user.blocked.friends"
#define kSettingsUserProviders      @"settings.user.providers"

@implementation UserModel

- (id) init {
	self = [super init];
	if (self != nil)
    {
        [self setDefoltValues];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self._id           = [decoder decodeObjectForKey:kSettingsUserId];
        self.avatarURL     = [decoder decodeObjectForKey:kSettingsUserAvatarURL];
        self.phone         = [decoder decodeObjectForKey:kSettingsUserPhone];
        self.socialId      = [decoder decodeObjectForKey:kSettingsUserSocialId];
        self.name          = [decoder decodeObjectForKey:kSettingsUserName];
        //self.password   = [decoder decodeObjectForKey:kSettingsUserSocialId];
//        self.email      = [decoder decodeObjectForKey:kSettingsUserEmail];
//        self.gender     = [decoder decodeObjectForKey:kSettingsUserGender];
//        self.country    = [decoder decodeObjectForKey:kSettingsUserCountry];
//        self.city       = [decoder decodeObjectForKey:kSettingsUserCity];
//        self.desc       = [decoder decodeObjectForKey:kSettingsUserDesc];
//        self.birthDate  = [decoder decodeObjectForKey:kSettingsUserBirthDate];
//        self.averages_scores = [decoder decodeObjectForKey:kSettingsUserAvgScores];
//        self.averages_speeds = [decoder decodeObjectForKey:kSettingsUserAvgSpeeds];
//        self.deviceId   = [decoder decodeObjectForKey:kSettingsUserDeviceId];
//        self.blockedPlayers = [decoder decodeObjectForKey:kSettingsUserBlokedFriends];
//        self.providersq = [decoder decodeObjectForKey:kSettingsUserProviders];
//        //self.blockedUsers
//        //self.password = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self._id           forKey:kSettingsUserId];
    [encoder encodeObject:self.avatarURL     forKey:kSettingsUserAvatarURL];
    [encoder encodeObject:self.phone         forKey:kSettingsUserPhone];
    [encoder encodeObject:self.socialId      forKey:kSettingsUserSocialId];
    [encoder encodeObject:self.name          forKey:kSettingsUserName];
   // [encoder encodeObject:self.password     forKey:kSettingsUserSocialId];
//    [encoder encodeObject:self.email        forKey:kSettingsUserEmail];
//    [encoder encodeObject:self.gender       forKey:kSettingsUserGender];
//    [encoder encodeObject:self.country      forKey:kSettingsUserCountry];
//    [encoder encodeObject:self.city         forKey:kSettingsUserCity];
//    [encoder encodeObject:self.desc         forKey:kSettingsUserDesc];
//    [encoder encodeObject:self.birthDate    forKey:kSettingsUserBirthDate];
//    [encoder encodeObject:self.averages_scores forKey:kSettingsUserAvgScores];
//    [encoder encodeObject:self.averages_speeds forKey:kSettingsUserAvgSpeeds];
//    [encoder encodeObject:self.deviceId     forKey:kSettingsUserDeviceId];
//    [encoder encodeObject:self.blockedPlayers forKey:kSettingsUserBlokedFriends];
//    [encoder encodeObject:self.providersq forKey:kSettingsUserProviders];
}


- (void) setDefoltValues
{
    self._id = 0;
    self.avatarURL = @"";
    self.phone = @"";
    self.socialId = @"";
    self.password = @"";
    self.nPassword = @"";
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil)
    {
        [self setDefoltValues];
        
        @try
        {
            id name = NULL_TO_NIL(dictionary[@"name"]);
            if (name) self.name = dictionary[@"name"];
            
            id phone = NULL_TO_NIL(dictionary[@"phone"]);
            if (phone) self.phone = dictionary[@"phone"];
            
            id ava = NULL_TO_NIL(dictionary[@"logo"]);
            if (ava) self.avatarURL = dictionary[@"logo"];
            
            id socialId = NULL_TO_NIL(dictionary[@"social"]);
            if (socialId) self.socialId = dictionary[@"social"];
        }
        @catch (NSException *exception) { STLogException(exception); }
    }
    return self;
}

- (NSDate *)dateFromLongLong:(long long)msSince1970
{
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}

- (long long)longLongFromDate:(NSDate*)date
{
    return [date timeIntervalSince1970] * 1000;
}

- (NSString *)description
{
    return @"";
}

//- (NSString *)userName {
//    // BugFix #103
//    // Замена двух пробелов в имени на один
//    return [_userName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
//}

@end
