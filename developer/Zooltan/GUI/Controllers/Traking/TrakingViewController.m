//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "TrakingViewController.h"
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>
#import "HistoryCell.h"
#import "CreateViewController.h"
#import "HistoryViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BLMultiColorLoader.h"
#import "DXStarRatingView.h"

#define layerCornerRadius 2.5
#define layerBorderWidth 1.5
#define circleWidth 3.5
#define delay 3.0f
#define avatarCornerRadius 30

@interface TrakingViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *courierView;
@property (weak, nonatomic) IBOutlet DXStarRatingView *starRatingView;
@property (weak, nonatomic) IBOutlet UIImageView *courierAvatar;
@property (weak, nonatomic) IBOutlet UILabel *courierNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *callCourierButton;

@property (weak, nonatomic) IBOutlet UIView *packageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *packageImageView;
@property (weak, nonatomic) IBOutlet UILabel *packageTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet BLMultiColorLoader *loaderView;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *orderSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdTtile;

@property (weak, nonatomic) IBOutlet UILabel *priceTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentTitle;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIButton *callSupportButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TrakingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startLoader];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopLoader];
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.cancelOrderButton.bottom+10);
}

- (void)configureView
{
    [super configureView];
    
    [self getOrderData];
    [self setMapView];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    self.navItem.title = NSLocalizedString(@"ctrl.traking.navigation.title", nil);
    self.packageTitleLabel.text = NSLocalizedString(@"ctrl.traking.title.main", nil);
    self.statusTitleLabel.text = NSLocalizedString(@"ctrl.traking.title.status", nil);
    self.packageTitle.text = NSLocalizedString(@"ctrl.traking.title.package", nil);
    self.orderIdTtile.text = NSLocalizedString(@"ctrl.traking.title.trackId", nil);
    self.priceTitle.text = NSLocalizedString(@"ctrl.traking.title.price", nil);
    self.commentTitle.text = NSLocalizedString(@"ctrl.traking.title.comments", nil);
    
    [self.callCourierButton setTitle:NSLocalizedString(@"ctrl.traking.title.callCourier.button", nil) forState:UIControlStateNormal];
    [self addCornerRadius:self.callCourierButton radius:layerCornerRadius];
    self.callCourierButton.layer.borderColor = [Colors whiteColor].CGColor;
    self.callCourierButton.layer.borderWidth = layerBorderWidth;
    
    [self.callSupportButton setTitle:NSLocalizedString(@"ctrl.traking.title.callSupport.button", nil) forState:UIControlStateNormal];
    [self addCornerRadius:self.callSupportButton radius:layerCornerRadius];
    self.callSupportButton.layer.borderColor = [Colors yellowColor].CGColor;
    self.callSupportButton.layer.borderWidth = layerBorderWidth;
    
    [self.cancelOrderButton setTitle:NSLocalizedString(@"ctrl.traking.title.cancelOrder.button", nil) forState:UIControlStateNormal];
    [self addCornerRadius:self.cancelOrderButton radius:layerCornerRadius];
    self.cancelOrderButton.layer.borderColor = [Colors yellowColor].CGColor;
    self.cancelOrderButton.layer.borderWidth = layerBorderWidth;
    
    if (self.order.orderStatus == OrderStatusNew) {
        self.courierView.hidden = YES;
        self.packageView.hidden = NO;
        self.statusView.backgroundColor = [Colors yellowColor];
    }
    else {
        self.courierView.hidden = NO;
        self.packageView.hidden = YES;
        self.statusView.backgroundColor = [Colors whiteColor];
    }
    
    if (self.order.orderStatus != OrderStatusNew && self.order.orderStatus != OrderStatusAccept) {
        self.cancelOrderButton.hidden = YES;
        self.cancelOrderButton.enabled = NO;
    }
    
    if (!self.packageImageView.image)
        self.packageView.backgroundColor = [Colors yellowColor];
    
    if (self.order.orderStatus != OrderStatusDelivery)
        self.starRatingView.hidden = YES;
    
    else {
        self.starRatingView.hidden = NO;
        [self.starRatingView setStars:0 callbackBlock:^(NSNumber *newRating) {
            [[Server instance] rateCourier:self.order.courierId withRaiting:newRating success:^{}
                                   failure:^(NSError *error, NSInteger code) {}];

        }];
    }
}

- (void)addCornerRadius:(UIButton *)btn radius:(float)radius
{
    btn.layer.cornerRadius = radius;
    btn.clipsToBounds = YES;
}

- (void)getOrderData
{
    [self setPackageImageFromUrl:[NSString stringWithFormat:@"http://%@", self.order.packageImageUrl]];
    [self setCourierAvatarFromUrl:self.order.courierLogoUrl];
    
    self.courierNameLabel.text = self.order.courierName;
    self.statusLabel.text = self.order.orderStatusTitle;
    
    if ([self.order.size isEqualToString:@"LETTER"])
        self.orderTypeImage.image = [UIImage imageNamed:@"letterPackage"];
    if ([self.order.size isEqualToString:@"SMALL_BOX"])
        self.orderTypeImage.image = [UIImage imageNamed:@"milkPackage"];
    if ([self.order.size isEqualToString:@"BIG_BOX"])
        self.orderTypeImage.image = [UIImage imageNamed:@"boxPackage"];
    
    self.orderSizeLabel.text = [self.order.size stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.orderIdLabel.text = self.order._id;
    self.priceLabel.text = self.order.cost;
    
    self.commentLabel.text = self.order.comment;
}

#pragma mark - set Google map
#pragma mark -

- (void)setMapView
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude zoom:15];
    self.mapView.camera = camera;
    self.mapView.userInteractionEnabled = NO;
    
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    
    GMSMarker *userMarker       = [GMSMarker markerWithPosition:userLocation];
    GMSMarker *pickupMarker     = [GMSMarker markerWithPosition:self.order.fromLocation];
    GMSMarker *reciverMarker    = [GMSMarker markerWithPosition:self.order.toLocation];
    
    userMarker.icon             = [UIImage imageNamed:@"user_dot"];
    pickupMarker.icon           = [UIImage imageNamed:@"pickup_dot"];
    reciverMarker.icon          = [UIImage imageNamed:@"reciver_dot"];
    
    userMarker.map              = self.mapView;
    pickupMarker.map            = self.mapView;
    reciverMarker.map           = self.mapView;
    
    CLLocation *packageLoc = [[CLLocation alloc] initWithLatitude:self.order.fromLocation.latitude longitude:self.order.fromLocation.longitude];
    CLLocation *destinationLoc = [[CLLocation alloc] initWithLatitude:self.order.toLocation.latitude longitude:self.order.toLocation.longitude];
    
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

#pragma mark - Courier Avatar
#pragma mark -

- (void)setCourierAvatarFromUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    [self.courierAvatar setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"emptyAvatar"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
        [self setCourierAvatarFromImage:image];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
}

- (void)setCourierAvatarFromImage:(UIImage *) image
{
    self.courierAvatar.image = image;
    self.courierAvatar.layer.cornerRadius = avatarCornerRadius;
    self.courierAvatar.clipsToBounds = YES;
}

#pragma mark - Package Image
#pragma mark -

- (void)setPackageImageFromUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    [self.packageImageView setImageWithURLRequest:request
                                 placeholderImage:nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
        self.packageImageView.image = image;
        self.packageImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.activityView.hidden = NO;
        self.packageTitleLabel.hidden = NO;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
}

#pragma mark - BLMultiColorLoader
#pragma mark -

- (void)startLoader
{
    self.loaderView.lineWidth = 2.7;
    self.loaderView.colorArray = @[[Colors yellowColor]];
    [self.loaderView startAnimation];
}

- (void)stopLoader
{
    [self.loaderView stopAnimation];
}

#pragma mark - IBAction
#pragma mark -

- (IBAction)back:(id)sender
{
    HistoryViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (IBAction)callCourierAction:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", self.order.phone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
        [[UIApplication sharedApplication] openURL:phoneUrl];
    else {
        [UIAlertView showAlertWithTitle:NSLocalizedString(@"generic.call", nil)
                                message:NSLocalizedString(@"ctrl.regestration.call.incopatible", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"generic.ok", nil)
                      otherButtonTitles:nil, nil];
    }
}

- (IBAction)callSupportAction:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", [Constants officeCallNumber]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
        [[UIApplication sharedApplication] openURL:phoneUrl];
    else {
        [UIAlertView showAlertWithTitle:NSLocalizedString(@"generic.call", nil)
                                message:NSLocalizedString(@"ctrl.regestration.call.incopatible", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"generic.ok", nil)
                      otherButtonTitles:nil, nil];
    }
}

- (IBAction)cancelAction:(id)sender
{
    switch (self.order.orderStatus)
    {
        case OrderStatusNew:        [self closeOrder]; break;
        case OrderStatusAccept:     [self closeOrder]; break;
        default: break;
    }
}

- (void)closeOrder
{
    STLogMethod;
    [[AppDelegate instance] showLoadingView];
    [[Server instance] updateOrder:self.order
                        withStatus:self.order.statusClose
                           success:^
     {
         [[AppDelegate instance] hideLoadingView];
         
         [self back:nil];
         
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

//#pragma mark - CHCircleGaugeView
//#pragma mark -
//
//- (CHCircleGaugeView *) setGauge
//{
//    CHCircleGaugeView *gauge = [[CHCircleGaugeView alloc] init];
//    //gauge.frame = CGRectMake(self.circleView.x, self.circleView.y, self.circleView.width, self.circleView.height);
//    [gauge setTranslatesAutoresizingMaskIntoConstraints:NO];
//    gauge.trackTintColor = [Colors redColor];
//    gauge.trackWidth = 10;
//    //gauge.gaugeWidth = 90;
//    gauge.gaugeTintColor = [UIColor blackColor];
//    gauge.textColor = [UIColor clearColor];
//    //gauge.value = 0.42;
//
//    return gauge;
//}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
