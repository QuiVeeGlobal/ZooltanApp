//
//  QRScannerViewController.h
//  Zooltan
//
//  Created by Eugene on 07.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "OrderModel.h"

@protocol QRScannerDelegate;

@interface QRScannerViewController : BaseViewController
@property (nonatomic, assign) id <QRScannerDelegate> delegate;
@property (nonatomic, strong) OrderModel *order;


@end

@protocol QRScannerDelegate <NSObject>

@optional
- (void)QRScannerDidFinishScan;

@end
