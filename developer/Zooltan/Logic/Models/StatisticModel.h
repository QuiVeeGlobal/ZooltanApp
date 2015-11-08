//
//  StatisticModel.h
//  Zooltan
//
//  Created by Eugene on 28.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    StatisticRangeDay, //0
    StatisticRangeWeek,//1
    StatisticRangeMonth,//2
} StatisticRange;


@interface StatisticModel : BaseModel

/* All stat */
@property (nonatomic, strong) NSNumber *profit;
@property (nonatomic, strong) NSNumber *allDeliveries;
@property (nonatomic, strong) NSNumber *rating;

/* For stat by Range */
@property (nonatomic, assign) StatisticRange statisticRange;
@property (nonatomic, strong) NSNumber *allMoneyReceived;
@property (nonatomic, strong) NSNumber *deliveries;
@property (nonatomic, strong) NSDate *dateFrom;
@property (nonatomic, strong) NSDate *dateEnd;

- (void)mappingAllStatisticDictionary:(NSDictionary *)dictionary;
- (void)mappingStatisticByRange:(StatisticRange)range
                 withDictionary:(NSDictionary *)dictionary;

- (NSString *)statisticRangeName;
@end
