//
//  UITableView+Additions.m
//  Dependencies
//
//  Created by Eugene Vegner on 25.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (CGFloat) tableHeaderHeight
{
    return self.tableHeaderView.height;
}

- (void) setTableHeaderHeight: (CGFloat) height
{
    UIView* header = self.tableHeaderView;
    header.height = height;
    self.tableHeaderView = nil;
    self.tableHeaderView = header;
}

- (CGFloat) tableFooterHeight
{
    return self.tableFooterView.height;
}

- (void) setTableFooterHeight: (CGFloat) height
{
    UIView* footer = self.tableFooterView;
    footer.height = height;
    self.tableFooterView = nil;
    self.tableFooterView = footer;
}

- (void) insertSectionAtIndex: (NSUInteger) index withRowAnimation:(UITableViewRowAnimation) animation
{
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex: index];
    [self insertSections: indexSet withRowAnimation: animation];
}

- (void) reloadSectionAtIndex: (NSUInteger) index withRowAnimation: (UITableViewRowAnimation) animation
{
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex: index];
    [self reloadSections: indexSet withRowAnimation: animation];
}

- (void) deleteSectionAtIndex: (NSUInteger) index withRowAnimation: (UITableViewRowAnimation) animation
{
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex: index];
    [self deleteSections: indexSet withRowAnimation: animation];
}

- (id) objectForKeyedSubscript: (id) indexPathOrCell
{
    if ([indexPathOrCell isKindOfClass: NSIndexPath.class])
        return [self cellForRowAtIndexPath: indexPathOrCell];
    
    if ([indexPathOrCell isKindOfClass: UITableViewCell.class])
        return [self indexPathForCell: indexPathOrCell];
    
    [NSException raise: @"ArgumentException" format: @"Argument is neither an index path nor a cell"];
    return nil;
}

@end
