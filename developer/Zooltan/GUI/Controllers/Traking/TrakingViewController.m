//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "TrakingViewController.h"
#import "CHCircleGaugeView.h"
#import "HistoryCell.h"
#import "CreateViewController.h"
#import "UIImageView+AFNetworking.h"

#define layerCornerRadius 2.5
#define layerBorderWidth 1.5
#define circleWidth 3.5
#define delay 3.0f
#define avatarCornerRadius 30

@interface TrakingViewController () <UIScrollViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet UILabel *courierNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courierImage;
@property (weak, nonatomic) IBOutlet UIImageView *typeDeliveryImage;

@property (weak, nonatomic) IBOutlet UILabel *typeDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *trackIdTitle;
@property (weak, nonatomic) IBOutlet UILabel *packageTitle;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *pickedUpTitle;
@property (weak, nonatomic) IBOutlet UILabel *enRouteTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentlyTitle;

@property (weak, nonatomic) IBOutlet UIButton *cellBtn;
@property (weak, nonatomic) IBOutlet UIView *yellowBgView;
@property (weak, nonatomic) IBOutlet CHCircleGaugeView *gaugeView;

@property (weak, nonatomic) IBOutlet UILabel *pickedUpPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickedUpTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enRoutePlace_1_Label;
@property (weak, nonatomic) IBOutlet UILabel *enRouteTime_1_Label;
@property (weak, nonatomic) IBOutlet UILabel *enRoutePlace_2_Label;
@property (weak, nonatomic) IBOutlet UILabel *enRouteTime_2_Label;
@property (weak, nonatomic) IBOutlet UILabel *currentlyPlaceLabel;

@end

@implementation TrakingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.cellBtn.bottom+10);
}

- (void)configureView
{
    [super configureView];
    
    [self getOrderData];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    self.yellowBgView.backgroundColor = [Colors yellowColor];
    
    [self addCornerRadius:self.cellBtn radius:layerCornerRadius];
    
    self.cellBtn.layer.borderColor = [Colors yellowColor].CGColor;
    self.cellBtn.layer.borderWidth = layerBorderWidth;
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.cellBtn.bottom+10);
    
    self.navTitle.text = NSLocalizedString(@"ctrl.traking.navigation.title", nil);
    self.packageTitle.text = NSLocalizedString(@"ctrl.traking.title.package", nil);
    self.trackIdTitle.text = NSLocalizedString(@"ctrl.traking.title.trackId", nil);
    self.pickedUpTitle.text = NSLocalizedString(@"ctrl.traking.title.pickedUp", nil);
    self.enRouteTitle.text = NSLocalizedString(@"ctrl.traking.title.enRoute", nil);
    self.currentlyTitle.text = NSLocalizedString(@"ctrl.traking.title.currently", nil);
    self.cellBtn.titleLabel.text = NSLocalizedString(@"ctrl.traking.btn.call", nil);
    
    //CHCircleGaugeView
    [self.gaugeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.gaugeView.trackTintColor = [Colors blackColor];
    self.gaugeView.textColor = [UIColor clearColor];
    self.gaugeView.gaugeTintColor = [Colors yellowColor];
    self.gaugeView.gaugeWidth = circleWidth;
    self.gaugeView.trackWidth = circleWidth;
    
    [self performBlock:^{
        if (self.order.orderStatus == OrderStatusAccept)
            [self.gaugeView setValue:0.25 animated:YES];
        if (self.order.orderStatus == OrderStatusPickUp)
            [self.gaugeView setValue:0.50 animated:YES];
        if (self.order.orderStatus == OrderStatusProgress)
            [self.gaugeView setValue:0.75 animated:YES];
        if (self.order.orderStatus == OrderStatusDelivery)
            [self.gaugeView setValue:1.0 animated:YES];
    } afterDelay:0.3];
}

- (void) getOrderData
{
    [self setUserAvatarFromUrl:self.order.courierLogoUrl];
    self.courierNameLabel.text = self.order.courierName;
    
    if ([self.order.size isEqualToString:@"LETTER"])
        self.typeDeliveryImage.image = [UIImage imageNamed:@"letter"];
    if ([self.order.size isEqualToString:@"SMALL_BOX"])
        self.typeDeliveryImage.image = [UIImage imageNamed:@"milkBox"];
    if ([self.order.size isEqualToString:@"BIG_BOX"])
        self.typeDeliveryImage.image = [UIImage imageNamed:@"big_box"];
    
    self.statusLabel.text = self.order.orderStatusTitle;
    self.deliveryIdLabel.text = self.order._id;
    self.pickedUpPlaceLabel.text = self.order.fromAddress;
    self.pickedUpTimeLabel.text = self.order.pickedUpDate;
}

#pragma mark - Courier Avatar
#pragma mark -

- (void) setUserAvatarFromUrl:(NSString *) url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    [self.courierImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"emptyAvatar"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.courierImage.image = image;
        [self setUserAvatarFromImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
}

- (void) setUserAvatarFromImage:(UIImage *) image
{
    self.courierImage.image = image;
    self.courierImage.layer.cornerRadius = avatarCornerRadius;
    self.courierImage.clipsToBounds = YES;
}

- (void) addCornerRadius:(UIButton *) btn radius:(float) radius
{
    btn.layer.cornerRadius = radius;
    btn.clipsToBounds = YES;
}

- (void) addBottomLineInLabel:(UILabel *) label
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, label.height-1, label.width, label.height);//textFild.height - borderWidth
    border.borderWidth = borderWidth;
    [label.layer addSublayer:border];
    label.clipsToBounds = YES;
    label.layer.masksToBounds = YES;
}

#pragma mark - IBAction
#pragma mark -

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


#pragma mark - CHCircleGaugeView
#pragma mark -

- (CHCircleGaugeView *) setGauge
{
    CHCircleGaugeView *gauge = [[CHCircleGaugeView alloc] init];
    //gauge.frame = CGRectMake(self.circleView.x, self.circleView.y, self.circleView.width, self.circleView.height);
    [gauge setTranslatesAutoresizingMaskIntoConstraints:NO];
    gauge.trackTintColor = [Colors redColor];
    gauge.trackWidth = 10;
    //gauge.gaugeWidth = 90;
    gauge.gaugeTintColor = [UIColor blackColor];
    gauge.textColor = [UIColor clearColor];
    //gauge.value = 0.42;
    
    return gauge;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
