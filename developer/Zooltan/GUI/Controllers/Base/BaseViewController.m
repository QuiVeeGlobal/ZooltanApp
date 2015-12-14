//
//  ViewController.h
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "BaseViewController.h"
#import "AuthorizationViewController.h"
#import "MenuViewController.h"
#import "CreateViewController.h"
#import "ProfileViewController.h"
#import "EAIntroView.h"

@interface BaseViewController () <UIScrollViewDelegate, EAIntroDelegate>
{
    UIBezierPath *navigationBarShadowPath;
    BaseViewController *destinationViewController;
}
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@end

@implementation BaseViewController

- (void)configureView
{
    STLogMethod;
    
    // Configure Tap Gesture for close keyboards
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(closeKeyboards)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenName = self.className;
    
    // Configure view
    [self configureView];

    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 524);
  }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createNotifications];
    
    // Disable navigation back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void) userInteractionEnabled:(BOOL) enabled
{
    self.view.userInteractionEnabled = enabled;
}

#pragma mark - Open Authorization

- (void)showLoginView
{
    STLogMethod;
    
    AuthorizationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthorizationViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ctr];
    navigationController.navigationBar.hidden = YES;
    [self presentViewController:navigationController
                       animated:NO
                     completion:nil];
}

#pragma mark - Open Tutorial

- (void)showTutorialView
{
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
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2, page3, page4]];
    [intro.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView
{
    NSLog(@"tutorialDidFinish callback");
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [introView hideWithFadeOutDuration:3.0];
}

#pragma mark -
#pragma mark -

- (void) getUserData
{
    NSLog(@"token %@", [[Settings instance] token]);
    
    //[[AppDelegate instance] showLoadingView];
    [[Server instance] getProfileSuccess:^(UserModel *userModel) {
        
        NSLog(@"SAVE!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        
        [[Settings instance] setCurrentUser:userModel];
        //[[AppDelegate instance] hideLoadingView];
    } failure:^(NSError *error, NSInteger code) {
        //[[AppDelegate instance] hideLoadingView];
    }];
}

#pragma mark -  naviration item action
#pragma mark -

- (IBAction)actionLeftMenu:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)actionRightMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (IBAction) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KeyboardNotifications

- (void)createNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notifications
{}

- (void)keyboardDidShow:(NSNotification *)notifications
{}

- (void)keyboardWillHide:(NSNotification *)notifications
{}

- (void)keyboardDidHide:(NSNotification *)notifications
{}

- (void)viewWillEnterForegroundNotification:(NSNotification *)notification {
}

#pragma mark - Open Controllers

- (BOOL)openViewController:(NSString *)destinationControllerName
{
    // Just close menu if current view controller == destination view controller
    
    if ([self.navigationController.topViewController.className isEqualToString:destinationControllerName])
        return YES;
    
    // Pop view controller from navigationController.viewControllers if available
    @try {
        for (UIViewController *viewController in self.navigationController.viewControllers)
        {
            if ([viewController.className isEqualToString:destinationControllerName])
            {
                [self.navigationController popToViewController:viewController animated:NO];
                return YES;
            }
        }
    }
    @catch (NSException *exception) {STLogException(exception);}
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        [self.navigationBar.layer setShadowOpacity:0.0f];
        [self.navigationBar.layer setShadowRadius:0.0f];
    }
    else
    {
        [self.navigationBar.layer setShadowOpacity:1.0f];
        [self.navigationBar.layer setShadowRadius:3.0f];
    }
    [self.navigationBar.layer setShadowPath:[navigationBarShadowPath CGPath]];
}

#pragma mark - Keybouard

- (void)closeKeyboards
{
    STLogMethod;
    [self.tableView endEditing:YES];
    [self.scrollView endEditing:YES];
    [self.view endEditing:YES];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
