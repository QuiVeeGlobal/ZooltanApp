//
//  NSDictionary(Additions).m
//  SITDependencies
//
//  Created by Eugene Vegner on 06.03.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)
@end

@implementation NSMutableDictionary (Additions)

- (BOOL) trySetObject: (id) object forKey: (id <NSCopying>) key
{
    if (object == nil || key == nil)
        return NO;

    [self setObject: object forKey: key];
    return YES;
}

- (void) replaceKey: (id <NSCopying>) oldKey with: (id <NSCopying>) newKey
{
    id value = [self objectForKey: oldKey];
    if (!value)
        return;

    [self setObject: value forKey: newKey];
    [self removeObjectForKey: oldKey];
}

@end