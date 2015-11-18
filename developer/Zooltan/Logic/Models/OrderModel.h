//
//  OrderModel.h
//  Zooltan
//
//  Created by Alex Sorokolita on 10.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "BaseModel.h"

@class RoutModel;

typedef enum : NSUInteger {
    OrderStatusNew,
    OrderStatusAccept,
    OrderStatusPickUp,
    OrderStatusProgress,
    OrderStatusDelivery,
    OrderStatusClose,
} OrderStatus;

@interface OrderModel : BaseModel

// Courier
@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *cost;
@property (nonatomic, retain) NSString *clientId;
@property (nonatomic, retain) NSString *clientLogo;
@property (nonatomic, retain) NSString *clientName;
@property (nonatomic, retain) NSString *receiverName;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *distanceBetween;
@property (nonatomic, retain) NSString *distanceTo;
@property (nonatomic, retain) NSString *destinationAddress;
@property (nonatomic, retain) NSString *packageAddress;
@property (nonatomic, retain) NSString *toAddress;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *trackId;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *packageImageUrl;
@property (nonatomic, strong) NSArray<RoutModel*> *routes;

// Client
@property (nonatomic, retain) NSString *pickedUpTime;
@property (nonatomic, retain) NSString *deliveredTime;
@property (nonatomic, retain) NSString *pickedUpDate;
@property (nonatomic, retain) NSString *fromAddress;
@property (nonatomic, retain) NSString *courierId;
@property (nonatomic, retain) NSString *courierLogoUrl;
@property (nonatomic, retain) NSString *courierName;

@property (nonatomic, assign) OrderStatus orderStatus;

@property (nonatomic, strong) NSString *currentAddress;

@property (nonatomic, assign) CLLocationCoordinate2D destinationLocation;
@property (nonatomic, assign) CLLocationCoordinate2D packageLocation;
@property (nonatomic, assign) CLLocationCoordinate2D fromLocation;

//- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)orderStatusTitle;
- (NSString *)hashCurrentLocationAddress;
- (OrderStatus)nextStatus;

// Routes
- (NSArray<RoutModel *>*)sortedRoutesById;
- (RoutModel *)firstRout;
- (RoutModel *)lastRout;



@end