//
//  PolicyViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 16.11.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "PolicyViewController.h"

@interface PolicyViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PolicyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.eu-central-1.amazonaws.com/legal.docs/PrivacyPolicy.html"]]];
}

- (void)configureView
{
    [super configureView];
    
    self.navItem.title = NSLocalizedString(@"ctrl.privacyPolicy.navigation.title", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
