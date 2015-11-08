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
    return 206;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.pickupTitleLabel.text = NSLocalizedString(@"ctrl.package.title.pickupDistance", nil);
    //self.destinationTitleLabel.text = NSLocalizedString(@"ctrl.package.title.betweenDistance", nil);
    //self.destinationAreaTitleLabel.text = NSLocalizedString(@"ctrl.package.title.destinationArea", nil);
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
