//
//  CourierHistoryViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 02.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "CourierHistoryViewController.h"
#import "OrderModel.h"
#import "CourierHistoryCell.h"
#import "AFNetworking.h"
#import "FromViewController.h"
#import "PackageViewController.h"

typedef enum : NSUInteger {
    SearchSegTypeLocal,
    SearchSegTypeWay,
    SearchSegTypeFullTime,
} SearchSegType;

typedef enum : NSUInteger {
    StatusSegTypeNew,
    StatusSegTypeActive,
    StatusSegTypeHistory,
} StatusSegType;

#define REQUEST self.manager

@interface CourierHistoryViewController () <CLLocationManagerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, CourierHistoryCellDelegate>
{
    BOOL searchIsOpen;
    float currentLatitude;
    float currentLongitude;
    float destinationLatitude;
    float destinationLongitude;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *topSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *bottomSegment;

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewVerticalConstraint;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, retain) PlaceModel *destinationAddress;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *ordersArray;
@property (strong, nonatomic) NSDictionary *currentPackageDic;

@property (strong, nonatomic) NSString *requerstUrl;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation CourierHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if (![[Settings instance] token] || [[[Settings instance] token] isEqualToString:@""])
        [self showLoginView];
    
    if (IS_COURIER_APP) {
        // Initialize the refresh control only for Courier
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor clearColor];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self
                                action:@selector(refreshTable)
                      forControlEvents:UIControlEventValueChanged];
        
        [self.tableView addSubview:self.refreshControl];
    }
}

- (void)refreshTable {
    [self getOrders];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    currentLatitude = self.locationManager.location.coordinate.latitude;
    currentLongitude = self.locationManager.location.coordinate.longitude;
    
    if (self.topSegment.selectedSegmentIndex == 1)
        self.mainViewVerticalConstraint.constant = 80;
    
    self.destinationAddress = [[Settings instance] destinationAddress];
    
    if (self.destinationAddress.formatted_address != 0) {
        self.addressLabel.text = self.destinationAddress.formatted_address;
        destinationLatitude = self.destinationAddress.location.latitude;
        destinationLongitude = self.destinationAddress.location.longitude;
    }
    else
        self.addressLabel.text = NSLocalizedString(@"ctrl.destination.label.title", nil);
    
    [self getOrders];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [kUserDefaults removeObjectForKey:@"settings_destinationAddress"];
}

- (void)configureView
{
    [super configureView];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    [self.topSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:[Colors yellowColor], NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:16]} forState:UIControlStateSelected];
    [self.topSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:14]} forState:UIControlStateNormal];
    
    self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title0", nil);
    
    [self.topSegment setTitle:NSLocalizedString(@"ctrl.courier.history.topnavigation.title0", nil) forSegmentAtIndex:0];
    [self.topSegment setTitle:NSLocalizedString(@"ctrl.courier.history.topnavigation.title1", nil) forSegmentAtIndex:1];
    [self.topSegment setTitle:NSLocalizedString(@"ctrl.courier.history.topnavigation.title2", nil) forSegmentAtIndex:2];
    
    [self.bottomSegment setTitle:NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title0", nil) forSegmentAtIndex:0];
    [self.bottomSegment setTitle:NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title1", nil) forSegmentAtIndex:1];
    [self.bottomSegment setTitle:NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title2", nil) forSegmentAtIndex:2];
}

- (void)getOrders
{
    if (!self.refreshControl.isRefreshing) {
        [[AppDelegate instance] showLoadingView];
    }
    
    if (!self.requerstUrl) {
        self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=local&longitude=%f&latitude=%f", currentLongitude, currentLatitude];
    }
    
    //    if (self.topSegment.selectedSegmentIndex == 1) {
    //        if (self.destinationAddress.formatted_address != 0) {
    //            self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=way&longitude=%f&latitude=%f&destination_longitude=%f&destination_latitude=%f", currentLongitude, currentLatitude, destinationLongitude, destinationLatitude];
    //        }
    //    }
    
    STLogDebug(@"--> self.requerstUrl: %@",self.requerstUrl);
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    [REQUEST GET:self.requerstUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         STLogSuccess(@"[%zd ]/courier/orders RESPONSE: %@",operation.response.statusCode, responseObject);
         
         if (operation.response.statusCode == 200 || operation.response.statusCode == 204)
         {
             self.ordersArray = responseObject[@"orders"];
             [self.tableView reloadData];
             [[AppDelegate instance] hideLoadingView];
             [self.refreshControl endRefreshing];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         STLogSuccess(@"/courier/orders failure: %@",operation.responseString);
         [[AppDelegate instance] hideLoadingView];
         [self.refreshControl endRefreshing];
     }];
}

- (void)showSearchView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.mainView.frame = CGRectMake(self.mainView.origin.x, self.mainView.origin.y + 60, self.mainView.size.width, self.mainView.size.height);
                     } completion:^(BOOL finished) {
                         self.searchView.hidden = NO;
                         searchIsOpen = YES;
                     }];
}

- (void)hideSearchView
{
    self.searchView.hidden = YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.mainView.frame = CGRectMake(self.mainView.origin.x, self.mainView.origin.y - 60, self.mainView.size.width, self.mainView.size.height);
                     } completion:^(BOOL finished) {
                         searchIsOpen = NO;
                     }];
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CourierHistoryCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.ordersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CourierHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourierHistoryCell"
                                                               forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    __block OrderModel *order = [[OrderModel alloc] initWithDictionary:self.ordersArray[indexPath.row]];
    
    cell.orderTypeLabel.text = [order.size stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    if ([order.size isEqualToString:@"LETTER"])
        cell.orderTypeImage.image = [UIImage imageNamed:@"letter_package"];
    if ([order.size isEqualToString:@"SMALL_BOX"])
        cell.orderTypeImage.image = [UIImage imageNamed:@"small_package"];
    if ([order.size isEqualToString:@"BIG_BOX"])
        cell.orderTypeImage.image = [UIImage imageNamed:@"big_package"];
    
    cell.costLabel.text = [NSString stringWithFormat:@"AED %@", order.cost];
    cell.pickupAddressLabel.text = order.fromAddress;
    cell.destinationAddressLabel.text = order.toAddress;
    cell.distanceBetweenLabel.text = [NSString stringWithFormat:@"%@ km", order.distance];
    cell.noteLabel.text = order.comment;
    
    if (order.orderStatus == OrderStatusDelivery)
        cell.distanceToPickupLabel.text = @"";
    else
        cell.distanceToPickupLabel.text = [NSString stringWithFormat:@"%@ km", order.distanceTo];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)courierHistoryCellDidPressButton:(UIButton *)button
                             atIndexPath:(NSIndexPath *)indexPath
{
    [[AppDelegate instance] showLoadingView];
    
    __block OrderModel *order = [[OrderModel alloc] initWithDictionary:self.ordersArray[indexPath.row]];
    
    [[Server instance] viewOrder:order success:^{
        [[AppDelegate instance] hideLoadingView];
        PackageViewController *ctr =
        [self.storyboard instantiateViewControllerWithIdentifier:@"PackageViewController"];
        ctr.order = order;
        [self.navigationController pushViewController:ctr animated:YES];
        
    } failure:^(NSError *error, NSInteger code) {
        [[AppDelegate instance] hideLoadingView];
    }];
}

#pragma mark - IBAction
#pragma mark -

- (IBAction)topSegmentAction:(id)sender
{
    switch (self.topSegment.selectedSegmentIndex) {
        case SearchSegTypeLocal:
            //self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=local&radius=5&longitude=%f&latitude=%f", currentLongitude, currentLatitude];
            if (searchIsOpen)
                [self hideSearchView];
            [self.bottomSegment setSelectedSegmentIndex:StatusSegTypeNew];
            self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title0", nil);
            
            break;
            
        case SearchSegTypeWay:
            //self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=wayss&longitude=%f&latitude=%f", currentLongitude, currentLatitude];
            [self showSearchView];
            [self.bottomSegment setSelectedSegmentIndex:StatusSegTypeNew];
            self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title0", nil);
            
            break;
            
        case SearchSegTypeFullTime:
            //self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=full&longitude=%f&latitude=%f", currentLongitude, currentLatitude];
            if (searchIsOpen)
                [self hideSearchView];
            [self.bottomSegment setSelectedSegmentIndex:StatusSegTypeNew];
            self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title0", nil);
            
            break;
            
        default:
            break;
    }
    [self bottomSegmentAction:self.bottomSegment];
}

- (IBAction)bottomSegmentAction:(id)sender
{
    switch (self.bottomSegment.selectedSegmentIndex) {
        case StatusSegTypeNew:
            
            switch (self.topSegment.selectedSegmentIndex) {
                case SearchSegTypeLocal:
                    self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=local&radius5&longitude=%f&latitude=%f",
                                        currentLongitude, currentLatitude];
                    break;
                case SearchSegTypeWay: {
                    if (self.destinationAddress.formatted_address != 0) {
                        self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=way&&radius25&longitude=%f&latitude=%f&destination_longitude=%f&destination_latitude=%f", currentLongitude, currentLatitude, destinationLongitude, destinationLatitude];
                    } else {
                        self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=none&longitude=%f&latitude=%f",
                                            currentLongitude, currentLatitude];
                    }
                } break;
                    
                case SearchSegTypeFullTime:
                    self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=full&radius50&longitude=%f&latitude=%f",
                                        currentLongitude, currentLatitude];
                    break;
            }
            
            
            //            if (self.topSegment.selectedSegmentIndex == 0) {
            //                self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=local&longitude=%f&latitude=%f", currentLongitude, currentLatitude];
            //            }
            //            if (self.topSegment.selectedSegmentIndex == 1) {
            //                if (self.destinationAddress.formatted_address != 0) {
            //                    self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=way&longitude=%f&latitude=%f&destination_longitude=%f&destination_latitude=%f", currentLongitude, currentLatitude, destinationLongitude, destinationLatitude];
            //                }
            //            }
            //            if (self.topSegment.selectedSegmentIndex == 2) {
            //                self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/1/100?type=full&longitude=%f&latitude=%f", currentLongitude, currentLatitude];
            //            }
            self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title0", nil);
            break;
            
        case StatusSegTypeActive:
            
            switch (self.topSegment.selectedSegmentIndex) {
                case SearchSegTypeLocal:
                    self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/active/1/100?type=local&radius5&longitude=%f&latitude=%f",
                                        currentLongitude, currentLatitude];
                    break;
                case SearchSegTypeWay: {
                    self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/active/1/100?type=way&longitude=%f&latitude=%f",
                                        currentLongitude, currentLatitude];
                } break;
                    
                case SearchSegTypeFullTime:
                    self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/active/1/100?type=full&radius50&longitude=%f&latitude=%f",
                                        currentLongitude, currentLatitude];
                    break;
            }
            self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title1", nil);
            break;
            
        case StatusSegTypeHistory:
            self.requerstUrl = [NSString stringWithFormat:@"/courier/orders/history/1/100"];
            self.navItem.title = NSLocalizedString(@"ctrl.courier.history.bottomnavigation.title2", nil);
            break;
            
        default:
            break;
    }
    STLogDebug(@"SELECTED: TOP:%zd  BOTTOM:%zd",
               self.topSegment.selectedSegmentIndex,
               self.bottomSegment.selectedSegmentIndex);
    [self getOrders];
}

- (IBAction)searchAction:(id)sender
{
    FromViewController *fromViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FromViewController"];
    fromViewController.addressType = DestinationAddress;
    
    [self.navigationController pushViewController:fromViewController animated:YES];
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[Constants baseURL]]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"application/json"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        _manager.responseSerializer = jsonResponseSerializer;
    }
    
    return _manager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
