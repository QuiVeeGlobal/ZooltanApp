//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "ExpanceViewController.h"
#import "HistoryCell.h"

@interface ExpanceViewController () <UIScrollViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UILabel *balanseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ExpanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
}

- (void)configureView
{
    [super configureView];
    
    self.bgView.backgroundColor = [Colors lightBlueColor];
    
    [self addBottomLineInLabel:self.rechargeLabel];
    [self addBottomLineInLabel:self.promoLabel];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    self.navItem.title = NSLocalizedString(@"ctrl.expense.navigation.title", nil);
    self.balanseTitleLabel.text = NSLocalizedString(@"ctrl.expense.title.balance", nil);
    self.rechargeTitleLabel.text = NSLocalizedString(@"ctrl.expense.title.recharge", nil);
    self.promoTitleLabel.text = NSLocalizedString(@"ctrl.expense.title.promo", nil);
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

- (IBAction)addPromoAction:(UIButton *) sender
{
}

- (IBAction)rechargeAction:(UIButton *) sender
{
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
