//
//  ViewController.h
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

#define SHOW_ACTIVITY [[AppDelegate sharedInstance] showLoadingView]
#define HIDE_ACTIVITY [[AppDelegate sharedInstance] hideLoadingView]

@interface BaseViewController : GAITrackedViewController

@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *menuButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UINavigationItem *navItem;

- (void) getUserData;

- (void)configureView;
- (void)viewWillEnterForegroundNotification:(NSNotification *)notification;
- (void)closeKeyboards;

- (void) userInteractionEnabled:(BOOL) enabled;

- (IBAction)actionLeftMenu:(id)sender;

- (void)showLoginView;
- (void)showTutorialView;

@end
