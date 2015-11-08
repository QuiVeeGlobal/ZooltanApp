

#import "PlaceModel.h"

#define kSettingsPlaceId                 @"settings.place.id"
#define kSettingsPlaceLocation_longitude @"settings.place.location.longitude"
#define kSettingsPlaceLocation_latitude  @"settings.place.location.latitude"
#define kSettingsPlaceFormattedAddress   @"settings.place.formatted_addres"
#define kSettingsPlaceName               @"settings.place.name"


@implementation PlaceModel

- (id) init {
	self = [super init];
	if (self != nil)
    {
        [self setDefoltValues];
	}
	return self;
}

- (void) setDefoltValues
{
    self._id = 0;
    self.name = @"";
}

- (id)initWithGMSAutocompletePrediction:(GMSAutocompletePrediction *)prediction {
    self = [super init];
    if (self != nil)
    {
        [self setDefoltValues];
        self.place_id = prediction.placeID;
        self.attributedAddressString = prediction.attributedFullText;
        self.formatted_address = prediction.attributedFullText.string;
        self._id = prediction.placeID;
    }
    return self;
}

- (void)updateWithGMSPlace:(GMSPlace *)place {

    if (!place) {
        return;
    }
    self.name = place.name;
    self.location = place.coordinate;
    self.formatted_address = place.formattedAddress;
    //self.attributedAddressString = place.attributions;
    self.place_id = place.placeID;
    self._id = place.placeID;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil)
    {
        [self setDefoltValues];
        
    
        @try
        {
            NSString *_id = NULL_TO_NIL(dictionary[@"id"]);
            if (_id) self._id = STRING(dictionary[@"id"]);
            
            NSString *name = NULL_TO_NIL(dictionary[@"name"]);
            if (name) self.name = STRING(dictionary[@"name"]);
            
            NSString *place_id = NULL_TO_NIL(dictionary[@"place_id"]);
            if (place_id) self.place_id = STRING(dictionary[@"place_id"]);
            
            NSString *icon = NULL_TO_NIL(dictionary[@"icon"]);
            if (icon) self.icon = STRING(dictionary[@"icon"]);
            
            NSString *reference = NULL_TO_NIL(dictionary[@"reference"]);
            if (reference) self.reference = STRING(dictionary[@"reference"]);
            
            
//            NSString *formatted_address = NULL_TO_NIL(dictionary[@"name"]);
//            if (formatted_address) self.formatted_address = STRING(dictionary[@"name"]);

            NSString *formatted_address = NULL_TO_NIL(dictionary[@"description"]);
            if (formatted_address) self.formatted_address = STRING(dictionary[@"description"]);
            
            NSString *geometry = NULL_TO_NIL(dictionary[@"geometry"]);
            if (geometry)
            {
                NSDictionary *geometryDic = (NSDictionary *)dictionary[@"geometry"];
                NSDictionary *locationDic = geometryDic[@"location"];
                
                CLLocationCoordinate2D location;
                location.latitude = [locationDic[@"lat"] floatValue];
                location.longitude = [locationDic[@"lng"] floatValue];
                
                self.location = location;
            }
        }
        @catch (NSException *exception) { STLogException(exception); }
    }
    return self;
}

- (id)initWithHomeDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil)
    {
        [self setDefoltValues];
        
        @try
        {
            NSString *home_address = NULL_TO_NIL(dictionary[@"home_address"]);
            if (home_address) self.formatted_address = STRING(dictionary[@"home_address"]);
            
            CLLocationCoordinate2D location;
            
            NSString *home_address_lat = NULL_TO_NIL(dictionary[@"home_address_lat"]);
            NSString *home_address_lon = NULL_TO_NIL(dictionary[@"home_address_lon"]);
            
            if (home_address_lat && home_address_lon)
            {
                location.latitude = [dictionary[@"home_address_lat"] floatValue];
                location.longitude = [dictionary[@"home_address_lon"] floatValue];
                
                self.location = location;
            }
        }
        @catch (NSException *exception) { STLogException(exception); }
    }
    return self;
}

- (id)initWithWorkDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil)
    {
        [self setDefoltValues];
        
        @try
        {
            NSString *work_address = NULL_TO_NIL(dictionary[@"work_address"]);
            if (work_address) self.formatted_address = STRING(dictionary[@"work_address"]);
            
            CLLocationCoordinate2D location;
            
            NSString *work_address_lat = NULL_TO_NIL(dictionary[@"work_address_lat"]);
            NSString *work_address_lon = NULL_TO_NIL(dictionary[@"work_address_lon"]);
            
            if (work_address_lat && work_address_lon)
            {
                location.latitude = [dictionary[@"work_address_lat"] floatValue];
                location.longitude = [dictionary[@"work_address_lon"] floatValue];
                
                self.location = location;
            }
        }
        @catch (NSException *exception) { STLogException(exception); }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init]))
    {
        CLLocationCoordinate2D location;
        
        self._id                    = [decoder decodeObjectForKey:kSettingsPlaceId];
        location.longitude          = [decoder decodeFloatForKey:kSettingsPlaceLocation_longitude];
        location.latitude           = [decoder decodeFloatForKey:kSettingsPlaceLocation_latitude];
        self.formatted_address      = [decoder decodeObjectForKey:kSettingsPlaceFormattedAddress];
        self.name                   = [decoder decodeObjectForKey:kSettingsPlaceName];
        
        self.location = location;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self._id                   forKey:kSettingsPlaceId];
    [encoder encodeFloat:self.location.longitude     forKey:kSettingsPlaceLocation_longitude];
    [encoder encodeFloat:self.location.latitude      forKey:kSettingsPlaceLocation_latitude];
    [encoder encodeObject:self.formatted_address     forKey:kSettingsPlaceFormattedAddress];
    [encoder encodeObject:self.name                  forKey:kSettingsPlaceName];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"PlaceModel [ID: %@ ] %@, latitude(%@), longitude(%@)",self.place_id, self.formatted_address, @(self.location.latitude), @(self.location.longitude)];
}

@end
