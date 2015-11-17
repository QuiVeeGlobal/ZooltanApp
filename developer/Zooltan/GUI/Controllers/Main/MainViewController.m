//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "MainViewController.h"
#import "AuthorizationViewController.h"
#import "RegistrationViewController.h"
#import "CreateViewController.h"
#import "PackagePhotoViewController.h"
#import "DeliveryCell.h"

#define layerCornerRadius 2.5

@interface MainViewController () <UIScrollViewDelegate, DeliveryCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendNew;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[Settings instance] token] || [[[Settings instance] token] isEqualToString:@""])
        [self showLoginView];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)configureView
{
    [super configureView];
    
    [self addCornerRadius:self.sendNew];
    
    self.navItem.title = NSLocalizedString(@"ctrl.history.navigationtitle", nil);
    self.mainLabel.text = NSLocalizedString(@"ctrl.main.title", nil);
    self.sendNew.titleLabel.text = NSLocalizedString(@"ctrl.main.button.sendNew", nil);
}

- (void)addCornerRadius:(UIButton *)btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction)create:(id)sender
{
    CreateViewController *createViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self.navigationController pushViewController:createViewController animated:YES];
    
//    PackagePhotoViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PackagePhotoViewController"];
//    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:showLogin
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
