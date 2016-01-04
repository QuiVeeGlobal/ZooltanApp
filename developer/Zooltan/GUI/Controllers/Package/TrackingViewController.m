//
//  TrackingViewController.m
//  Zooltan
//
//  Created by Eugene Vegner on 14.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "TrackingViewController.h"
#import "TrackingViewCell.h"

typedef enum : NSUInteger {
    UITableViewSectionPickedUp,
    UITableViewSectionEnRoute,
    UITableViewSectionCurrently,
    UITableViewSectionCount,
} UITableViewSection;

#define kCellHeight 30.0

@interface TrackingViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _trackerIsOpened;
    BOOL _isTracking;
    NSString *_lastHashOrderLocation;
}

@property (nonatomic, strong) NSArray<RoutModel*> *source;

- (IBAction)openCloseTrackingAction:(id)sender;

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _trackerIsOpened = NO;
    _isTracking = NO;
    _source = @[];
    [self.trackingButton setTitle:NSLocalizedString(@"ctrl.tracking.button.title", nil)
                         forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(trackLocationNotification:)
//                                                 name:kNotificationTrackLocation
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:kNotificationTrackLocation
//                                                  object:nil];
}

//#pragma mark - Track Location Notification
//
//- (void)trackLocationNotification:(NSNotification *)notification {
//    CLLocation *location = [[AppDelegate instance] currentLocation];
//
//    NSDictionary *pos = notification.object;
//    if (location.coordinate.latitude == 0 ||
//        location.coordinate.longitude == 0 ||
//        ![pos isKindOfClass:[NSDictionary class]] ||
//        !self.order) {
//        return;
//    }
//    STLogDebug(@"notification: %@",notification.object);
//        
//    if (![_lastHashOrderLocation isEqualToString:self.order.hashCurrentLocationAddress]) {
//        _lastHashOrderLocation = self.order.hashCurrentLocationAddress;
//        [self trackingOrderFetcher];
//    }
//}


- (IBAction)openCloseTrackingAction:(id)sender
{
    if (!_trackerIsOpened && self.order.routes.count == 0) {
        return;
    }
    
    __block CGFloat trackerHeight = (_trackerIsOpened) ? 44 : 320;
    self.trackingButton.enabled = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        (_trackerIsOpened)
        ? [self updateTrackingViewHeight:trackerHeight]
        : (self.view.height = trackerHeight);
        
    } completion:^(BOOL finished) {
        (_trackerIsOpened)
        ? (self.view.height = trackerHeight)
        : [self updateTrackingViewHeight:trackerHeight];
        _trackerIsOpened = !_trackerIsOpened;
        self.trackingButton.enabled = YES;
    }];
}

- (void)updateTrackingOrder {
    self.source = self.order.sortedRoutesById;
}

- (void)updateTrackingViewHeight:(CGFloat)height {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTrackingViewDidUpdate
                                                        object:@(height)];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return UITableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case UITableViewSectionPickedUp:
        case UITableViewSectionCurrently:
            return 1;
        default:
            switch (self.source.count) {
                case 0: case 1: case 2: return 0;
                default: return self.source.count-2;
            }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TrackingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TrackingViewCell.className
                                                             forIndexPath:indexPath];

    RoutModel *rout;
    switch (indexPath.section) {
        case UITableViewSectionPickedUp: rout = self.source.firstObject; break;
        case UITableViewSectionCurrently: rout = self.source.lastObject; break;
        default: {
            switch (self.source.count) {
                case 0: case 1: case 2: rout = nil; break;
                default: rout = self.source[indexPath.row+1];
            }
        } break;
    }
    [cell configureWithRout:rout];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.height)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, kCellHeight)];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.font = [UIFont systemFontOfSize:12];// [UIFont fontWithName:@"OpenSans-Regular" size:12];
    headerLabel.textColor = [UIColor lightTextColor];
    
    switch (section) {
        case UITableViewSectionPickedUp:
            headerLabel.text = NSLocalizedString(@"ctrl.tracking.section.title.pickedup", nil);
            break;
            
        case UITableViewSectionEnRoute:
            headerLabel.text = NSLocalizedString(@"ctrl.tracking.section.title.enroute", nil);
            break;
        
        case UITableViewSectionCurrently:
            headerLabel.text = NSLocalizedString(@"ctrl.tracking.section.title.currently", nil);
            break;

        default: headerLabel.text = nil; break;
    }
    [view addSubview:headerLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCellHeight+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}


//#pragma mark - Fetcher
//
//- (void)trackingOrderFetcher {
//
//    if (_isTracking) {
//        return;
//    }
//    
//    [self performBlock:^{
//        _isTracking = YES;
//        
//        [[Server instance] trackingOrder:self.order success:^{
//            _isTracking = NO;
//            [self.tableView reloadData];
//            
//        } failure:^(NSError *error, NSInteger code) {
//            _isTracking = NO;
//        }];
//
//    } afterDelay:1];
//}

@end
