//
//  StatisticModel.m
//  Zooltan
//
//  Created by Eugene on 28.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "StatisticModel.h"

@implementation StatisticModel

- (void)mappingAllStatisticDictionary:(NSDictionary *)dictionary {
    STLogMethod;
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.profit = NULL_TO_NIL(dictionary[@"sum"]);
    self.allDeliveries = NULL_TO_NIL(dictionary[@"deliveries"]);
    self.rating = NULL_TO_NIL(dictionary[@"rating"]);
}

- (void)mappingStatisticByRange:(StatisticRange)range
                 withDictionary:(NSDictionary *)dictionary {
    STLogMethod;
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    /* For all statistic */
    self.statisticRange = range;
    self.allMoneyReceived = NULL_TO_NIL(dictionary[@"sum"]);
    self.deliveries = NULL_TO_NIL(dictionary[@"deliveries"]);
}

- (NSString *)statisticRangeName {
    switch (self.statisticRange) {
        case StatisticRangeDay: return @"day";
        case StatisticRangeWeek: return @"week";
        case StatisticRangeMonth: return @"month";
        default: return @"day";
    }
}


@end
