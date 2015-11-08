//
//  UITableViewCell+Additions.m
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "UITableViewCell+Additions.h"

@implementation UITableViewCell (Additions)

+ (id) cellWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString*) reuseIdentifier
{
    return [[UITableViewCell alloc] initWithStyle: style reuseIdentifier: reuseIdentifier];
}

+ (id) cellFromNib: (UINib*) nib withReuseIdentifier: (NSString*) reuseIdentifier
{
    NSArray* topLevelObjects = [nib instantiateWithOwner: nil options: nil];
    return [topLevelObjects firstObjectPassingTest: ^(id obj)
            {
                UITableViewCell* cell = obj;
                return (BOOL) ([cell isKindOfClass: [self class]]
                               && [cell.reuseIdentifier isEqualToString: reuseIdentifier]);
            }];
}

@end
