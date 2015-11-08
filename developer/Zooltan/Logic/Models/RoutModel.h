//
//  RoutModel.h
//  Zooltan
//
//  Created by Eugene Vegner on 21.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "BaseModel.h"

@interface RoutModel : BaseModel
@property (nonatomic, strong) NSNumber *routId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timeString;

@end
