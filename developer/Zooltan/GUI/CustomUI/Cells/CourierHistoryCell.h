//
//  CourierHistoryCell.h
//  Zooltan
//
//  Created by Alex Sorokolita on 02.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourierHistoryCellDelegate;

@interface CourierHistoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *bgView;

@property (nonatomic, weak) IBOutlet UIImageView *orderTypeImage;
@property (nonatomic, weak) IBOutlet UILabel *orderTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;

@property (nonatomic, weak) IBOutlet UILabel *pickupTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceToPickupLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupAddressLabel;

@property (nonatomic, weak) IBOutlet UILabel *destinationTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceBetweenLabel;
@property (nonatomic, weak) IBOutlet UILabel *destinationAddressLabel;

//@property (nonatomic, weak) IBOutlet UILabel *destinationAreaTitleLabel;
//@property (nonatomic, weak) IBOutlet UILabel *destinationAreaLabel;

@property (nonatomic, assign) id <CourierHistoryCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol CourierHistoryCellDelegate <NSObject>

@optional

- (void)courierHistoryCellDidPressButton:(UIButton *)button
                             atIndexPath:(NSIndexPath *)indexPath;

@end
