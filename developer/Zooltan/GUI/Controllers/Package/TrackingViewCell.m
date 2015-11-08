//
//  TrackingViewCell.m
//  Zooltan
//
//  Created by Eugene Vegner on 22.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "TrackingViewCell.h"

@implementation TrackingViewCell

- (void)awakeFromNib {
    self.timeLabel.textColor = [Colors yellowColor];
    self.nameLabel.textColor = [Colors yellowColor];
}

- (void)configureWithRout:(RoutModel *)rout {
    self.rout = rout;
    self.timeImageView.image = nil;
    
    self.nameLabel.text = STRING(self.rout.name);
    self.timeLabel.text = STRING(self.rout.timeString);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
