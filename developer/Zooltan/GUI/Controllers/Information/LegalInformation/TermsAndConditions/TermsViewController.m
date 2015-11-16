//
//  TermsViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 16.11.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.eu-central-1.amazonaws.com/legal.docs/TermsAndConditions.html"]]];
}

- (void)configureView
{
    [super configureView];
    
    self.navItem.title = NSLocalizedString(@"ctrl.termsAndConditions.navigation.title", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
