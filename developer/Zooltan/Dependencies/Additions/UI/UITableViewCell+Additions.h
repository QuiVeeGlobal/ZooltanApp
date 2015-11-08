//
//  UITableViewCell+Additions.h
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Additions)
+ (id) cellWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString*) reuseIdentifier;
+ (id) cellFromNib: (UINib*) nib withReuseIdentifier: (NSString*) reuseIdentifier;

@end
