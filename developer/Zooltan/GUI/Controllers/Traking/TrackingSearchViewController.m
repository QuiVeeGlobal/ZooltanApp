//
//  TrackingSearchViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 20.08.15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "TrackingSearchViewController.h"
#import "HistoryViewController.h"
#import "CHCircleGaugeView.h"

#define layerCornerRadius 2.5
#define layerBorderWidth 1.5
#define circleWidth 3.5
#define delay 3.0f

@interface TrackingSearchViewController ()

@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet UILabel *typeDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *typeDeliveryImage;

@property (weak, nonatomic) IBOutlet UILabel *trackIdTitle;
@property (weak, nonatomic) IBOutlet UILabel *packageTitle;

@property (weak, nonatomic) IBOutlet CHCircleGaugeView *gaugeView;

@end

@implementation TrackingSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)configureView
{
    [super configureView];
    
    [self getOrderData];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    //CHCircleGaugeView
    [self.gaugeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.gaugeView.trackTintColor = [Colors blackColor];
    self.gaugeView.textColor = [UIColor clearColor];
    self.gaugeView.gaugeTintColor = [Colors yellowColor];
    self.gaugeView.gaugeWidth = circleWidth;
    self.gaugeView.trackWidth = circleWidth;
    
    self.navTitle.text = NSLocalizedString(@"ctrl.traking.navigation.title", nil);
    self.packageTitle.text = NSLocalizedString(@"ctrl.traking.title.package", nil);
    self.trackIdTitle.text = NSLocalizedString(@"ctrl.traking.title.trackId", nil);
    
    [self performBlock:^{
        [self.gaugeView setValue:0.42 animated:YES];
    } afterDelay:0.3];
}

- (void) getOrderData
{
    self.deliveryIdLabel.text = self.order._id;
    self.statusLabel.text = self.order.status;
    self.typeDeliveryLabel.text = [self.order.size stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    if ([self.order.size isEqualToString:@"LETTER"])
        self.typeDeliveryImage.image = [UIImage imageNamed:@"letter_package"];
    if ([self.order.size isEqualToString:@"SMALL_BOX"])
        self.typeDeliveryImage.image = [UIImage imageNamed:@"small_package"];
    if ([self.order.size isEqualToString:@"BIG_BOX"])
        self.typeDeliveryImage.image = [UIImage imageNamed:@"big_package"];
}

#pragma mark - IBAction
#pragma mark -

- (IBAction)backAction:(id)sender
{
    HistoryViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
