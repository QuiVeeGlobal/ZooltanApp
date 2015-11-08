//
//  TrackingViewCell.h
//  Zooltan
//
//  Created by Eugene Vegner on 22.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *timeImageView;

@property (nonatomic, strong) RoutModel *rout;

- (void)configureWithRout:(RoutModel *)rout;

@end
