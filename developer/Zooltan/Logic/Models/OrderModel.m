//
//  OrderModel.m
//  Zooltan
//
//  Created by Alex Sorokolita on 10.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "OrderModel.h"

#define kOrderStatusKeyNew      @"new"
#define kOrderStatusKeyAccept   @"accept"
#define kOrderStatusKeyPickUp   @"picked_up"
#define kOrderStatusKeyProgress @"progress"
#define kOrderStatusKeyDelivered @"delivered"
#define kOrderStatusKeyClosed   @"closed"


@implementation OrderModel
@synthesize orderStatus = _orderStatus;

//- (id)initWithDictionary:(NSDictionary *)dictionary
//{
//    self = [super init];
//    if (self != nil)
//    {
//        
//    }
//    return self;
//}

- (void)mappingDictionary:(NSDictionary *)dictionary {
    
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self._id             = STRING(NULL_TO_NIL(dictionary[@"id"]));
    self.trackId         = STRING(NULL_TO_NIL(dictionary[@"track_id"]));
    self.status          = STRING(NULL_TO_NIL(dictionary[@"status"]));
    self.receiverName    = STRING(NULL_TO_NIL(dictionary[@"receiver"]));
    self.distance        = STRING(NULL_TO_NIL(dictionary[@"distance"]));
    self.distanceBetween = STRING(NULL_TO_NIL(dictionary[@"distance_between"]));
    self.distanceTo      = STRING(NULL_TO_NIL(dictionary[@"distance_to"]));
    self.cost            = STRING(NULL_TO_NIL(dictionary[@"cost"]));
    self.phone           = STRING(NULL_TO_NIL(dictionary[@"phone"]));
    self.size            = STRING(NULL_TO_NIL(dictionary[@"size"]));
    self.pickedUpDate    = STRING(NULL_TO_NIL(dictionary[@"date_picked_up"]));
    self.comment         = STRING(NULL_TO_NIL(dictionary[@"comment"]));
    self.packageImageUrl = STRING(NULL_TO_NIL(dictionary[@"image"]));
    
    // From location
    CLLocationCoordinate2D fromLoc;
    
    NSString *from_lat   = NULL_TO_NIL(dictionary[@"from_lat"]);
    NSString *from_lon   = NULL_TO_NIL(dictionary[@"from_lon"]);
    
    if (from_lat && from_lon)
    {
        fromLoc.latitude    = [from_lat floatValue];
        fromLoc.longitude   = [from_lon floatValue];
    }
    self.fromLocation    = fromLoc;
    
    // To location
    CLLocationCoordinate2D toLoc;
    
    NSString *to_lat   = NULL_TO_NIL(dictionary[@"to_lat"]);
    NSString *to_lon   = NULL_TO_NIL(dictionary[@"to_lon"]);
    
    if (to_lat && to_lon)
    {
        toLoc.latitude    = [to_lat floatValue];
        toLoc.longitude   = [to_lon floatValue];
    }
    self.toLocation    = toLoc;
    
    // Destination location
    CLLocationCoordinate2D destLoc;
    id destination = NULL_TO_NIL(dictionary[@"destination"]);
    if ([destination isKindOfClass:[NSDictionary class]]) {
        self.destinationAddress     = STRING(destination[@"name"]);
        
        NSString *destination_lat   = NULL_TO_NIL(destination[@"latitude"]);
        NSString *destination_lon   = NULL_TO_NIL(destination[@"longitude"]);
        
        if (destination_lat && destination_lon)
        {
            destLoc.latitude        = [destination_lat floatValue];
            destLoc.longitude       = [destination_lon floatValue];
        }
    }
    self.destinationLocation        = destLoc;
    
    // Pack location
    CLLocationCoordinate2D packLoc;
    
    NSString *package_lat   = NULL_TO_NIL(dictionary[@"package_latitude"]);
    NSString *package_lon   = NULL_TO_NIL(dictionary[@"package_longitude"]);
    
    if (package_lat && package_lon)
    {
        packLoc.latitude    = [package_lat floatValue];
        packLoc.longitude   = [package_lon floatValue];
    }
    self.packageLocation    = packLoc;
    
    self.packageAddress     = STRING(NULL_TO_NIL(dictionary[@"package_address"]));

    // Client
    
    id client               = NULL_TO_NIL(dictionary[@"client"]);
    if ([client isKindOfClass:[NSDictionary class]]) {
        self.clientId       = STRING(NULL_TO_NIL(client[@"id"]));
        self.clientLogo     = NULL_TO_NIL(client[@"logo"]);
        self.clientName     = NULL_TO_NIL(client[@"name"]);
    }
    
    // Courier
    
    id courier               = NULL_TO_NIL(dictionary[@"courier"]);
    if ([courier isKindOfClass:[NSDictionary class]]) {
        self.courierId       = STRING(NULL_TO_NIL(courier[@"id"]));
        self.courierLogoUrl  = NULL_TO_NIL(courier[@"logo"]);
        self.courierName     = NULL_TO_NIL(courier[@"name"]);
    }
    
    self.pickedUpTime        = STRING(NULL_TO_NIL(dictionary[@"picked_up"]));
    self.deliveredTime       = STRING(NULL_TO_NIL(dictionary[@"delivered"]));
    self.fromAddress         = STRING(NULL_TO_NIL(dictionary[@"from_address"]));
    self.toAddress           = STRING(NULL_TO_NIL(dictionary[@"to_address"]));
    
    // Routes
    
    id routes                = NULL_TO_NIL(dictionary[@"routes"]);
    NSMutableArray *newRoutes= [NSMutableArray array];
    if ([routes isKindOfClass:[NSArray class]]) {
        [routes enumerateObjectsUsingBlock:^(id  _Nonnull routObj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([routObj isKindOfClass:[NSDictionary class]]) {
                RoutModel *rout = [[RoutModel alloc] initWithDictionary:routObj];
                [newRoutes addObject:rout];
            }
        }];
    }
    self.routes = newRoutes;
}

- (NSString *)orderStatusTitle {
    switch (self.orderStatus) {
        case OrderStatusNew:        return NSLocalizedString(@"ctrl.package.order.status.new", nil);
        case OrderStatusAccept:     return NSLocalizedString(@"ctrl.package.order.status.accept", nil);
        case OrderStatusPickUp:     return NSLocalizedString(@"ctrl.package.order.status.pickup", nil);
        case OrderStatusProgress:   return NSLocalizedString(@"ctrl.package.order.status.progress", nil);
        case OrderStatusDelivery:   return NSLocalizedString(@"ctrl.package.order.status.delivery", nil);
        case OrderStatusClose:      return NSLocalizedString(@"ctrl.package.order.status.close", nil);
        default: return nil;
    }
}

- (OrderStatus)orderStatus {
    _orderStatus = [self statusByKey:self.status];
    return _orderStatus;
}

- (void)setOrderStatus:(OrderStatus)orderStatus {
    _orderStatus = orderStatus;
    switch (orderStatus) {
        case OrderStatusNew:        self.status = kOrderStatusKeyNew; break;
        case OrderStatusAccept:     self.status = kOrderStatusKeyAccept; break;
        case OrderStatusPickUp:     self.status = kOrderStatusKeyPickUp; break;
        case OrderStatusProgress:   self.status = kOrderStatusKeyProgress; break;
        case OrderStatusDelivery:   self.status = kOrderStatusKeyDelivered; break;
        case OrderStatusClose:      self.status = kOrderStatusKeyClosed; break;
        default: self.status = kOrderStatusKeyNew;
    }
}

- (OrderStatus)statusByKey:(NSString *)key {

    /*
     "status": "new/accept/picked_up/progress/delivered/closed",
     */
    
    if ([key isKindOfClass:[NSString class]]) {
        if ([key isEqualToString:kOrderStatusKeyNew]) {
            return OrderStatusNew;
        } else if ([key isEqualToString:kOrderStatusKeyAccept]) {
            return OrderStatusAccept;
        } else if ([key isEqualToString:kOrderStatusKeyPickUp]) {
            return OrderStatusPickUp;
        } else if ([key isEqualToString:kOrderStatusKeyProgress]) {
            return OrderStatusProgress;
        } else if ([key isEqualToString:kOrderStatusKeyDelivered]) {
            return OrderStatusDelivery;
        } else if ([key isEqualToString:kOrderStatusKeyClosed]) {
            return OrderStatusClose;
        }
    }
    return OrderStatusNew;
}

- (NSString *)hashCurrentLocationAddress {
    if (!self.currentAddress || self.currentAddress.length < 1) {
        return nil;
    }
    return self.currentAddress.sha1;
}

- (OrderStatus)nextStatus {
    switch (self.orderStatus) {
        case OrderStatusNew: return OrderStatusAccept;
        case OrderStatusAccept: return OrderStatusPickUp;
        case OrderStatusPickUp: return OrderStatusProgress;
        case OrderStatusProgress: return OrderStatusDelivery;
        //case OrderStatusDelivery: return OrderStatusClose;
        default: return OrderStatusClose;
    }
}

- (OrderStatus)statusClose {
    switch (self.orderStatus) {
        default: return OrderStatusClose;
    }
}

#pragma mark - Sorted Routes

- (NSArray<RoutModel *>*)sortedRoutesById {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"routId" ascending:YES];
    return [self.routes sortedArrayUsingDescriptors:@[sort]];
}

- (RoutModel *)firstRout {
    return [[self sortedRoutesById] firstObject];
}

- (RoutModel *)lastRout {
    return [[self sortedRoutesById] lastObject];
}


#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"OrderModel: id=%@, status=%@",self._id,self.status];
}

@end
