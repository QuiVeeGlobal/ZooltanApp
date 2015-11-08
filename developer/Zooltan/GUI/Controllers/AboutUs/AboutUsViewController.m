//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "AboutUsViewController.h"
#import "HistoryCell.h"

@interface AboutUsViewController () <UIScrollViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *followingTitleLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
}

- (void)configureView
{
    [super configureView];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    self.navItem.title = NSLocalizedString(@"ctrl.aboutus.navigation.title", nil);
    self.descriptionView.text = NSLocalizedString(@"ctrl.aboutus.title.description", nil);
    self.followingTitleLabel.text = NSLocalizedString(@"ctrl.aboutus.title.following", nil);
    
    self.descriptionView.font = [Fonts setOpenSansWithFontSize:16];
    self.descriptionView.textAlignment = NSTextAlignmentCenter;
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

- (IBAction) facebookAction:(UIButton *) sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.facebook.com/zooltanapp"]];
}

- (IBAction) twitterAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/zooltanapp"]];
}

- (IBAction) siteAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.zooltan.com"]];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
