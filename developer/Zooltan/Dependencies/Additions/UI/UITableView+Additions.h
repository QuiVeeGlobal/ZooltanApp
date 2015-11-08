//
//  UITableView+Additions.h
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Additions)
@property (nonatomic, assign) CGFloat tableHeaderHeight;
@property (nonatomic, assign) CGFloat tableFooterHeight;

- (void) insertSectionAtIndex: (NSUInteger) index withRowAnimation: (UITableViewRowAnimation) animation;
- (void) reloadSectionAtIndex: (NSUInteger) index withRowAnimation: (UITableViewRowAnimation) animation;
- (void) deleteSectionAtIndex: (NSUInteger) index withRowAnimation: (UITableViewRowAnimation) animation;

- (id) objectForKeyedSubscript: (id) indexPathOrCell;

@end
