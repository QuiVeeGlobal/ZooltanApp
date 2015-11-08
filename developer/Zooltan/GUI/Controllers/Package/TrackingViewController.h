//
//  TrackingViewController.h
//  Zooltan
//
//  Created by Eugene Vegner on 14.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "BaseViewController.h"

#define kNotificationTrackingViewDidUpdate @"kNotificationTrackingViewDidUpdate"

@interface TrackingViewController : BaseViewController
@property (nonatomic, weak) IBOutlet UIButton *trackingButton;
@property (nonatomic, strong) OrderModel *order;

@end
