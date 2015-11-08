//
//  TestViewViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 7/7/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@property (nonatomic, weak) IBOutlet UIView *clearanceView;
@property (nonatomic, weak) IBOutlet UILabel *mainLabel;
@property (nonatomic, weak) IBOutlet UITextView *descTextView;
@property (nonatomic, weak) IBOutlet UILabel *travelTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *additionalTitleLabel;

@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configureView
{
    [super configureView];
    
    self.navItem.title = NSLocalizedString(@"ctrl.useragreement.navigation.title", nil);
    self.mainLabel.text = NSLocalizedString(@"ctrl.useragreement.title.mainlabel", nil);
    self.descTextView.text = NSLocalizedString(@"ctrl.useragreement.title.description", nil);
    self.travelTimeLabel.text = NSLocalizedString(@"ctrl.useragreement.title.treveltime", nil);
    self.additionalTitleLabel.text = NSLocalizedString(@"ctrl.useragreement.title.additional", nil);
    
    self.descTextView.font = [Fonts setOpenSansWithFontSize:16];
    self.descTextView.textAlignment = NSTextAlignmentCenter;
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.clearanceView.bottom);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
