//
//  NSDictionary(Additions).h
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)
@end

@interface NSMutableDictionary (Additions)

- (BOOL) trySetObject: (id) object forKey: (id <NSCopying>) key;
- (void) replaceKey: (id <NSCopying>) oldKey with: (id <NSCopying>) newKey;

@end