//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "HistoryViewController.h"
#import "ExpanceViewController.h"
#import "AboutUsViewController.h"
#import "InformationViewController.h"
#import "PackageViewController.h"

#define layerCornerRadius 2.5

@interface MenuViewController ()
{
}

@property (weak, nonatomic) IBOutlet TextField *phoneRecField;
@property (weak, nonatomic) IBOutlet UIView *profileBG;
@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *userName;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProfile];
}

- (void) getProfile
{
    [[AppDelegate instance] showLoadingView];
    [[Server instance] getProfileSuccess:^(UserModel *userModel) {
        [self setData:userModel];
        [[AppDelegate instance] hideLoadingView];
    } failure:^(NSError *error, NSInteger code) {
        [[AppDelegate instance] hideLoadingView];
    }];
}

- (void) setData:(UserModel *) userModel
{
    self.userName.text = userModel.name;
}

- (void)configureView
{
    [super configureView];
    self.profileBG.backgroundColor = [Colors yellowColor];
    
    self.priceLabel.text = @"$99.99";
    
    self.priceLabel.layer.cornerRadius = self.priceLabel.height/2;
    self.priceLabel.clipsToBounds = YES;
    self.priceLabel.backgroundColor = [Colors yellowColor];
    
    [self addCornerRadius:self.sendBtn];
    
    float labelWeidth = (float)self.priceLabel.text.length*12;
    
    if (self.priceLabel.text.length <= 2)
        labelWeidth = 28;
    else if (self.priceLabel.text.length >= 7)
        labelWeidth = 80;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.priceLabel.frame = CGRectMake(self.priceLabel.x, self.priceLabel.y, labelWeidth, self.priceLabel.height);
                     }];
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) categoryAction:(UIButton *)sender
{    
    switch (sender.tag) {
        case 0:
            [self showProfileView];
            break;
        case 1:
        {
            ExpanceViewController *expanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpanceViewController"];
            [self.navigationController pushViewController:expanceViewController animated:YES];
        }   break;
        case 2:
        {
            HistoryViewController *historyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
            [self.navigationController pushViewController:historyViewController animated:YES];
        }   break;
        case 3:
        {
            InformationViewController *informationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            [self.navigationController pushViewController:informationViewController animated:YES];
        }   break;
        case 4:
        {
            AboutUsViewController *aboutUsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
            [self.navigationController pushViewController:aboutUsViewController animated:YES];
        }   break;
        case 5:
        {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }   break;
            
        default:
            break;
    }
}

- (void) showProfileView
{
    ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
