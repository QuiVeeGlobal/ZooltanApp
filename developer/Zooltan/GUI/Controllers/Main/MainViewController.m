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
#import "DeliveryCell.h"
//#import "Auth0Client.h"
//#import <Auth0Client.h>

#define layerCornerRadius 2.5

@interface MainViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, DeliveryCellDelegate>

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
    self.tableView.alpha = NO;
    
    self.navItem.title = NSLocalizedString(@"ctrl.history.navigationtitle", nil);
    self.mainLabel.text = NSLocalizedString(@"ctrl.main.title", nil);
    self.sendNew.titleLabel.text = NSLocalizedString(@"ctrl.main.button.sendNew", nil);
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) create:(id)sender
{
    CreateViewController *createViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self.navigationController pushViewController:createViewController animated:YES];
}

- (IBAction) addDelivery:(id)sender
{
    self.tableView.alpha = YES;
    
//    A0Lock *lock = [[MyApplication sharedInstance] lock];
//    A0APIClient *client = [lock apiClient];
//    
//    A0APIClientAuthenticationSuccess success = ^(A0UserProfile *profile, A0Token *token) {
//        NSLog(@"extraInfo %@",  profile.extraInfo);
//        NSLog(@"We did it!. Signed up and logged in with Auth0!. %@ %@ %@", profile.name, profile.userId, profile.email);
//    };
//    A0APIClientError error = ^(NSError *error){
//        NSLog(@"Oops something went wrong: %@", error);
//    };
//    
//    [client loginWithUsername:@"trololo@gmail.com"
//                     password:@"1234567"
//                   parameters:nil
//                      success:success
//                      failure:error];
//    
//    return;
    
//    A0Lock *lock = [[MyApplication sharedInstance] lock];
//    A0APIClient *client = [lock apiClient];
//    A0APIClientAuthenticationSuccess success = ^(A0UserProfile *profile, A0Token *token) {
//        NSLog(@"extraInfo %@",  profile.extraInfo);
//        NSLog(@"333333333 We did it!. Signed up and logged in with Auth0!.");
//    };
//    
//    A0APIClientError error = ^(NSError *error){
//        //NSLog(@"4444444444 Oops something went wrong: %@", error.);
//
//        NSLog(@"code %zd", error.code);
//        NSLog(@"domain %@", error.domain);
//        //NSLog(@"Error authenticating: %@ - %@", [error objectForKey:@"error"], [error objectForKey:@"error_description"]);
//        //NSLog(@"4444444444 Oops something went wrong: %@", error);
//    };
//    [client signUpWithUsername:@"grigoriizaliva@gmail.com"
//                      password:@"1234567"
//                loginOnSuccess:YES
//                    parameters:nil
//                       success:success
//                       failure:error];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:showLogin
                                                  object:nil];
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DeliveryCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    DeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:DeliveryCell.className
                                                            forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)deliveryCellDidPressButton:(UIButton *)button
                       atIndexPath:(NSIndexPath *)indexPath
{
    STLogMethod;
}

- (void) showActivDelivery
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
