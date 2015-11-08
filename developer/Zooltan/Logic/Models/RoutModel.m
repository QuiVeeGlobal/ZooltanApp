//
//  RoutModel.m
//  Zooltan
//
//  Created by Eugene Vegner on 21.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "RoutModel.h"

@implementation RoutModel

- (void)mappingDictionary:(NSDictionary *)dictionary {
    [super mappingDictionary:dictionary];
    
    self.routId = NULL_TO_NIL(dictionary[@"id"]);
    self.name = NULL_TO_NIL(dictionary[@"name"]);
    self.timeString = NULL_TO_NIL(dictionary[@"time"]);
}

@end
