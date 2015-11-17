//
//  CourierHistoryCell.m
//  Zooltan
//
//  Created by Alex Sorokolita on 02.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "CourierHistoryCell.h"

@implementation CourierHistoryCell

+ (CGFloat)cellHeight
{
    return 233;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    self.pickupTitle.text = NSLocalizedString(@"ctrl.package.title.pickupDistance", nil);
    self.destinationTitle.text = NSLocalizedString(@"ctrl.package.title.betweenDistance", nil);
    self.noteTitle.text = NSLocalizedString(@"ctrl.package.title.note", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction) touchCell:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(courierHistoryCellDidPressButton:atIndexPath:)])
        [self.delegate courierHistoryCellDidPressButton:nil atIndexPath:self.indexPath];
}

@end
