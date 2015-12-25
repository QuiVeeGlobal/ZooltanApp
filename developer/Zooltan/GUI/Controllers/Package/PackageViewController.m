//
//  PackageViewController.m
//  Zooltan
//
//  Created by Eugene on 08.09.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "PackageViewController.h"
#import "QRScannerViewController.h"
#import "TrackingViewController.h"
#import "PhotoViewerViewController.h"
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>

@interface PackageViewController () <GMSMapViewDelegate, CLLocationManagerDelegate, QRScannerDelegate>
{
    BOOL _trackerIsOpened;
    TrackingViewController *_trackingViewController;
}

@property (weak, nonatomic) IBOutlet UIView *greenCallView;
@property (weak, nonatomic) IBOutlet UIView *topOrangeView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *trackingView;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *callSenderButton;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;
@property (weak, nonatomic) IBOutlet UIButton *viewPhotoButton;

@property (weak, nonatomic) IBOutlet UILabel *packageTitle;
@property (weak, nonatomic) IBOutlet UILabel *statusTitle;
@property (weak, nonatomic) IBOutlet UILabel *trackIdTitle;

@property (weak, nonatomic) IBOutlet UILabel *packageSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageTrackIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *costTitle;
@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UILabel *photoAttachedTitle;
@property (weak, nonatomic) IBOutlet UILabel *pickUpDistanceTitle;
@property (weak, nonatomic) IBOutlet UILabel *betweenDistanceTitle;
@property (weak, nonatomic) IBOutlet UILabel *receiverNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *receiverPhoneTitle;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickUpAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *betweenDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PackageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)configureView
{
    [super configureView];
    
    [self getPackageData];
    
    [self setMapView];
    
    self.topOrangeView.backgroundColor = [Colors yellowColor];
    
    self.greenCallView.layer.cornerRadius = self.greenCallView.height/2;
    self.greenCallView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.greenCallView.layer.borderWidth = 4;
    
    self.callButton.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 4);
    self.callButton.imageView.width = 10;
    self.callButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navItem.title = NSLocalizedString(@"ctrl.package.navigation.title", nil);
    self.packageTitle.text = NSLocalizedString(@"ctrl.package.title.package", nil);
    self.statusTitle.text = NSLocalizedString(@"ctrl.package.title.status", nil);
    self.trackIdTitle.text = NSLocalizedString(@"ctrl.package.title.trackId", nil);
    self.costTitle.text = NSLocalizedString(@"ctrl.package.title.cost", nil);
    self.noteTitle.text = NSLocalizedString(@"ctrl.package.title.note", nil);
    self.photoAttachedTitle.text = NSLocalizedString(@"ctrl.package.title.photoAttached", nil);
    self.pickUpDistanceTitle.text = NSLocalizedString(@"ctrl.package.title.pickupDistance", nil);
    self.betweenDistanceTitle.text = NSLocalizedString(@"ctrl.package.title.betweenDistance", nil);
    self.receiverNameTitle.text = NSLocalizedString(@"ctrl.package.title.receiverName", nil);
    self.receiverPhoneTitle.text = NSLocalizedString(@"ctrl.package.title.receiverPhone", nil);
    [self.callSenderButton setTitle:NSLocalizedString(@"ctrl.package.title.callSender", nil) forState:UIControlStateNormal];
    
    self.takeButton.layer.cornerRadius = kViewCornerRadius;
    [self updateView];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(self.view.width,self.trackingView.bottom);
    });

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(trackingViewDidUpdateNotification:)
                                                 name:kNotificationTrackingViewDidUpdate
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationTrackingViewDidUpdate
                                                  object:nil];
}

- (void)getPackageData
{
    self.packageTrackIdLabel.text     = self.order.trackId;
    self.packageSizeLabel.text        = [self.order.size stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.costLabel.text               = [NSString stringWithFormat:@"AED %@", self.order.cost];
    self.betweenDistanceLabel.text    = [NSString stringWithFormat:@"%@ km", self.order.distanceBetween];
    self.receiverNameLabel.text       = self.order.receiverName;
    self.pickUpAddressLabel.text      = self.order.packageAddress;
    self.destinationAddressLabel.text = self.order.destinationAddress;
    self.noteLabel.text               = self.order.comment;
    
    if (self.order.orderStatus == OrderStatusDelivery)
        self.pickUpDistanceLabel.text = @"";
    else
        self.pickUpDistanceLabel.text = [NSString stringWithFormat:@"%@ km", self.order.distanceTo];
    
    [self.callButton setTitle:self.order.phone forState:UIControlStateNormal];
}

- (void)openQRCodeScanner
{
    QRScannerViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:QRScannerViewController.className];
    ctrl.order = self.order;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)updateView
{
    [self updateStatusTitle];
    [self updateTakeButton];
}

#pragma mark - set Google map
#pragma mark -

- (void)setMapView
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera   = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude zoom:15];
    self.mapView.camera         = camera;
    self.mapView.userInteractionEnabled = NO;
    
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    
    GMSMarker *userMarker       = [GMSMarker markerWithPosition:userLocation];
    GMSMarker *pickupMarker     = [GMSMarker markerWithPosition:self.order.packageLocation];
    GMSMarker *reciverMarker    = [GMSMarker markerWithPosition:self.order.destinationLocation];
    
    userMarker.icon             = [UIImage imageNamed:@"user_dot"];
    pickupMarker.icon           = [UIImage imageNamed:@"pickup_dot"];
    reciverMarker.icon          = [UIImage imageNamed:@"reciver_dot"];
    
    userMarker.map              = self.mapView;
    pickupMarker.map            = self.mapView;
    reciverMarker.map           = self.mapView;
    
    CLLocation *packageLoc = [[CLLocation alloc] initWithLatitude:self.order.packageLocation.latitude longitude:self.order.packageLocation.longitude];
    CLLocation *destinationLoc = [[CLLocation alloc] initWithLatitude:self.order.destinationLocation.latitude longitude:self.order.destinationLocation.longitude];
    
    OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginLocation:packageLoc andDestinationLocation:destinationLoc];
    OCDirectionsAPIClient *client = [OCDirectionsAPIClient new];
    [request setTravelMode:OCDirectionsRequestTravelModeDriving];
    
    [client directions:request response:^(OCDirectionsResponse *response,  NSError *error) {
        
        if (error)
            return;
        
        if (response.status != OCDirectionsResponseStatusOK)
            return;
        
        NSString *points = response.dictionary[@"routes"][0][@"overview_polyline"][@"points"];
        
//        GMSPolyline *polyPath       = [GMSPolyline polylineWithPath:[GMSPath pathFromEncodedPath:points]];
//        polyPath.strokeColor        = [UIColor blueColor];
//        polyPath.strokeWidth        = 3.0f;
//        polyPath.map                = self.mapView;
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:[GMSPath pathFromEncodedPath:points]];
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(70, 70, 70, 70)];
        [self.mapView moveCamera:update];
        
        //NSLog(@"RESPONSE %@", response.dictionary);
        
    }];
}

#pragma mark - Actions

- (IBAction)viewPhotoAction:(id)sender
{
    PhotoViewerViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewerViewController"];
    ctr.order = self.order;
    [self.navigationController presentViewController:ctr animated:YES completion:nil];
}

- (IBAction)callAction:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", self.order.phone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        
    } else {
        [UIAlertView showAlertWithTitle:NSLocalizedString(@"generic.call", nil)
                                message:NSLocalizedString(@"ctrl.regestration.call.incopatible", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"generic.ok", nil)
                      otherButtonTitles:nil, nil];
    }
}

- (IBAction)takePackageAction:(UIButton *)sender
{
    switch (self.order.orderStatus) {
        case OrderStatusNew:        [self updateStatus]; break;
        case OrderStatusAccept:     [self openQRCodeScanner]; break;
        case OrderStatusPickUp:     [self updateStatus]; break;
        case OrderStatusProgress:   [self openQRCodeScanner]; break;
        case OrderStatusDelivery:   [self updateStatus]; break;
        default: break;
    }
}

- (void)updateTakeButton {
    
    NSString *title;
    
    switch (self.order.orderStatus) {
            
        case OrderStatusProgress:
            title = NSLocalizedString(@"ctrl.package.button.title.finish", nil);
            break;
            
        case OrderStatusPickUp:
            title = NSLocalizedString(@"ctrl.package.button.title.start", nil);
            break;
            
        case OrderStatusAccept:
            title = NSLocalizedString(@"ctrl.package.button.title.take", nil);
            break;

        case OrderStatusDelivery:
            self.takeButton.hidden = YES;
            //title = NSLocalizedString(@"ctrl.package.button.title.close", nil);
            break;
        
        case OrderStatusClose:
            self.takeButton.hidden = YES;
            break;
            
        default:
            title = NSLocalizedString(@"ctrl.package.button.title.accept", nil);
            break;
    }
    
    [self.takeButton setTitle:title
                     forState:UIControlStateNormal];

}

- (void)updateStatusTitle {
    self.packageStatusLabel.text = self.order.orderStatusTitle;
    STLogDebug(@"Update order: %@", self.order);
}

#pragma mark - QRScanner Delegate

- (void)QRScannerDidFinishScan {
    [self updateView];
}

#pragma mark - Update Order Status

- (void)updateStatus {
    
    STLogMethod;
    [[AppDelegate instance] showLoadingView];
    [[Server instance] updateOrder:self.order
                        withStatus:self.order.nextStatus
                           success:^
     {
         [self updateTakeButton];
         [self updateStatusTitle];
         [[AppDelegate instance] hideLoadingView];

     } failure:^(NSError *error, NSInteger code) {
         
         [[AppDelegate instance] hideLoadingView];
         switch (code) {
             case 403: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.403", nil) target:self]; break;
             case 404: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.updateOrder.404", nil) target:self]; break;
             case 409: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.updateOrder.409", nil) target:self]; break;
             default:
                 [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                 break;
         }
     }];
}

#pragma mark - TrackingView Update

- (void)trackingViewDidUpdateNotification:(NSNotification *)notification {
    STLogMethod;
    CGFloat trackingViewHeight = [notification.object floatValue];
    CGFloat contentHight = self.trackingView.y + trackingViewHeight;
    self.scrollView.contentSize = CGSizeMake(self.view.width, contentHight);
    [self.scrollView scrollRectToVisible:CGRectMake(0, self.trackingView.y, self.trackingView.width, trackingViewHeight)
                                animated:YES];
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"TrackingViewSegue"])
    {
        _trackingViewController = [segue destinationViewController];
        _trackingViewController.order = self.order;
    }
}

@end
