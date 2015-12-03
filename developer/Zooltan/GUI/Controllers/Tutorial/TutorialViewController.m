//
//  TutorialViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 04.12.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "TutorialViewController.h"
#import "AuthorizationViewController.h"
#import "EAIntroView.h"

@interface TutorialViewController () <EAIntroDelegate>

@property (nonatomic, weak) IBOutlet EAIntroView *tutorialView;

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"This is page 1";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.tutorialView.bounds andPages:@[page1, page2, page3, page4]];
    [intro.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [intro setDelegate:self];
    
    [intro showInView:self.tutorialView animateDuration:0.3];
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView
{
    NSLog(@"tutorialDidFinish callback");
    
    AuthorizationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthorizationViewController"];
    [self presentViewController:ctr animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
