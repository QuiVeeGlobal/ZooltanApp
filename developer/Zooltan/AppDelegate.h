//
//  AppDelegate.h
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CATransform3D.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <HockeySDK/HockeySDK.h>
#import "MyApplication.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MMDrawerVisualState.h"
#import "MMDrawerController.h"
#import "LeftMenuViewController.h"
#import "MainViewController.h"
#import "PlaceModel.h"
#import "BaseNavigationCtrl.h"


@class BaseNavigationCtrl;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocationManager  *locationManager;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BaseNavigationCtrl *rootNavigationCtrl;
@property (strong, nonatomic) MMDrawerController *drawerMenu;

@property (nonatomic, retain) LeftMenuViewController *leftMenu;
@property (nonatomic, retain) MainViewController *mainView;

@property (nonatomic, retain) PlaceModel *currentPlace;
@property (nonatomic, retain) NSString *currentAdrees;

@property (nonatomic, retain) BaseNavigationCtrl *navigation;

- (NSURL *)applicationDocumentsDirectory;

- (MMDrawerController *)configureDrawerMenuWithLeft:(id)left andCenter:(id)center;

+ (AppDelegate *)instance;
- (void)showLoadingView;
- (void)hideLoadingView;


@end

