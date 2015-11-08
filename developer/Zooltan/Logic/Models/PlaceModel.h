

#import "PlaceModel.h"
#import <MapKit/MapKit.h>
#import "BaseModel.h"

@interface PlaceModel : BaseModel

@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSString *radius;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *formatted_address;
@property (nonatomic, retain) NSString *place_id;
@property (nonatomic, retain) NSString *reference;
@property (nonatomic, retain) NSString *types;

@property (nonatomic, retain) NSAttributedString *attributedAddressString;



- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithHomeDictionary:(NSDictionary *)dictionary;
- (id)initWithWorkDictionary:(NSDictionary *)dictionary;

- (id)initWithGMSAutocompletePrediction:(GMSAutocompletePrediction *)prediction;
- (void)updateWithGMSPlace:(GMSPlace *)place;

@end
