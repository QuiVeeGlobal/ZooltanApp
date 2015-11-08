

#import "BaseModel.h"
#import "PlaceModel.h"


@class VkAccountModel, FbAccountModel, Country;
@class ProviderModel;

@interface UserModel : BaseModel

@property (nonatomic, assign) NSNumber *_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) NSString *socialId;

@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *nPassword;

@property (nonatomic, retain) NSString *socialHash;

@property (nonatomic, retain) PlaceModel *homeAddress;
@property (nonatomic, retain) PlaceModel *workAddress;

@property (nonatomic, assign) BOOL isFB;

@end
