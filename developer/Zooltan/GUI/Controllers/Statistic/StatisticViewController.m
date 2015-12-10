//
//  StatisticViewController.m
//  Zooltan
//
//  Created by Eugene on 25.09.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "StatisticViewController.h"

@interface StatisticViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *allMoneyRecievedTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *allMoneyRecievedValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *profitTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *profitValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *deliveriesTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *deliveriesValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *allDeliveriesTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *allDeliveriesValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingValueLabel;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navItem.title = NSLocalizedString(@"ctrl.statistic.navigation.title", nil);
    
    UIImage *img = [[UIImage imageNamed:@"statBgImage"]
                    resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10)
                    resizingMode:UIImageResizingModeStretch];
    self.badgeImageView.contentMode = UIViewContentModeScaleToFill;
    self.badgeImageView.alpha = 0.75;
    self.badgeImageView.image = img;
    
    
    [self.segmentControl setTitle:[NSLocalizedString(@"generic.day", nil) uppercaseString]
                forSegmentAtIndex: StatisticRangeDay];
    [self.segmentControl setTitle:[NSLocalizedString(@"generic.week", nil) uppercaseString]
                forSegmentAtIndex: StatisticRangeWeek];
    [self.segmentControl setTitle:[NSLocalizedString(@"generic.month", nil) uppercaseString]
                forSegmentAtIndex: StatisticRangeMonth];
    [self.segmentControl setSelectedSegmentIndex:StatisticRangeDay];
    

    // Localization strings
    self.profitTitleLabel.text          = NSLocalizedString(@"ctrl.statistic.title.profit", nil);
    self.ratingTitleLabel.text          = NSLocalizedString(@"ctrl.statistic.title.rating", nil);
    self.deliveriesTitleLabel.text      = NSLocalizedString(@"ctrl.statistic.title.deliveries", nil);
    self.allDeliveriesTitleLabel.text   = NSLocalizedString(@"ctrl.statistic.title.allDeliveries", nil);
    self.allMoneyRecievedTitleLabel.text= NSLocalizedString(@"ctrl.statistic.title.allMoneyRecived", nil);
 
    // Default values
    self.ratingValueLabel.text = @"0";
    self.dateLabel.text = @"";
    self.allMoneyRecievedValueLabel.text = @"0 $";
    self.deliveriesValueLabel.text = @"0";
    self.profitValueLabel.text = @"0 $";
    self.allDeliveriesValueLabel.text = @"0";

    // Load firs statistics for Day
    [self changeSegmentAction:StatisticRangeDay];
}

- (void)updateContent {
    STLogMethod;
    
    self.ratingValueLabel.text = STRING(self.statistics.rating);
    self.dateLabel.text = STRING(self.statistics.dateEnd);
    self.allMoneyRecievedValueLabel.text = [NSString stringWithFormat:@"%@ $",STRING(self.statistics.allMoneyReceived)];
    self.deliveriesValueLabel.text = STRING(self.statistics.deliveries);
    self.profitValueLabel.text = [NSString stringWithFormat:@"%@ $",STRING(self.statistics.profit)];
    self.allDeliveriesValueLabel.text = STRING(self.statistics.allDeliveries);
}

#pragma mark - Action

- (IBAction)changeSegmentAction:(UISegmentedControl *)sender
{
    STLogMethod;
    StatisticRange range = (StatisticRange)sender.selectedSegmentIndex;
    
    [[AppDelegate instance] showLoadingView];
    [[Server instance] statisticsByRange:range success:^(StatisticModel *statistic) {
       
        self.statistics = statistic;
        [self updateContent];
        [[AppDelegate instance] hideLoadingView];
        
    } failure:^(NSError *error, NSInteger code) {
        [[AppDelegate instance] hideLoadingView];
        switch (code) {
            case 403: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.403", nil) target:self]; break;
            default:
                [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                break;
        }
    }];
}


@end
