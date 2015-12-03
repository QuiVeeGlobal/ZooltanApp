//
//  AppDelegate.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AuthorizationViewController.h"
#import "Analytics.h"
#import <LeanTesting/LeanTesting.h>
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    ActivityIndicator *loadingView;
}

+ (AppDelegate*)instance
{
    return ((AppDelegate*)[UIApplication sharedApplication].delegate);
}

- (PlaceModel *)currentPlace {
    if (!_currentPlace) {
        _currentPlace = [PlaceModel new];
    }
    return _currentPlace;
}

#pragma mark - LoadingView

-(void)createLoadingView
{
    loadingView = [[ActivityIndicator alloc] initWithFrame:CGRectZero];
    [self.window addSubview:loadingView ];
    loadingView.hidden = YES;
}

-(void)showLoadingView
{
    [loadingView startSpinner];
    loadingView.hidden = NO;
    [self.window bringSubviewToFront:loadingView];
    self.window.userInteractionEnabled = NO;
}

-(void)hideLoadingView
{
    [loadingView stopSpinner];
    [loadingView setHidden:YES];
    self.window.userInteractionEnabled = YES;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.softintouch.Travel" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGeneralNavigationBar];
    
    //Lean Testing
    [LeanTesting activateSDKWithKey:[Constants leanTestingKey] projectID:[Constants leanTestingId]];
    
    //Google Analytics
    [[Analytics instance] startGAI];
    
    //Google Maps
    [GMSServices provideAPIKey:[Constants GMSApiKey]];
    
    //Google Directions API
    [OCDirectionsAPIClient provideAPIKey:[Constants browserGMSApiKey]];
    
    //CheckMobi
    [[CheckMobi instance] start];
    
    //Hockey
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier: [Constants hockeyApiKey]];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];
    
    // Start STLogger
    [[Logger instance] start];
    [[Logger instance] setLevelMask:LoggerLevelAll];
    
    [Utilities getAllContacts];
    
    //Window
    self.navigation = (BaseNavigationCtrl *)self.window.rootViewController;
    self.navigation.navigationBarHidden = YES;
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Constants currentStoryboardName]
                                                         bundle:nil];
    
    if (IS_CUSTOMER_APP)
        self.mainView = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    else
        self.mainView = [storyboard instantiateViewControllerWithIdentifier:@"CourierHistoryViewController"];
    
    [self.navigation setViewControllers:@[self.mainView]];
    
    self.navigation = [[BaseNavigationCtrl alloc] initWithRootViewController:self.mainView];
    self.navigation.navigationBarHidden = YES;
    
    self.leftMenu = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    
    MMDrawerController *drawerController = [self configureDrawerMenuWithLeft:self.leftMenu
                                                                   andCenter:self.navigation];
    self.drawerMenu = drawerController;
    
    STLogInfo(@"self.drawerMenu: %@",self.drawerMenu);
    STLogDebug(@">>Shared app: %@",[[NSBundle mainBundle] infoDictionary]);
    
    [self.window addSubview:self.drawerMenu.view];
    [self.window setRootViewController:self.drawerMenu];
    [self.window makeKeyAndVisible];
    
    if (IS_CUSTOMER_APP)
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                 didFinishLaunchingWithOptions:launchOptions];
    [self createLoadingView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if (IS_CUSTOMER_APP)
        if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"fb%@",kFacebookAppId]])
            return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma merk -
#pragma merk - Configure NavBar

- (void)configureGeneralNavigationBar {
    STLogMethod;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundColor:[Colors yellowColor]];
    
    UIImage *bgNavBar = [UIImage imageWithColor:[Colors yellowColor]];
    [[UINavigationBar appearance] setBackgroundImage:bgNavBar forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:bgNavBar forBarMetrics:UIBarMetricsLandscapePhone];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
}

#pragma mark - CLLocationManager Delegates

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   self.currentLocation = locations.lastObject;

//    [[Server instance] GMSCurrentPlaceSuccess:^(NSArray *places) {
//        //
//        PlaceModel *place = places.firstObject;
//        self.currentAdrees = place.formatted_address;
//        self.currentLocation = [[CLLocation alloc] initWithLatitude:place.location.latitude
//                                                          longitude:place.location.longitude];
//
//        
//        
//        
//        STLogDebug(@"[%@] - %@",self.currentLocation,self.currentAdrees);
//        
//    } failure:nil];
    
    
    //STLogDebug(@"longitude:%f latitude:%f", self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         [geocoder reverseGeocodeLocation:self.currentLocation
                        completionHandler:^(NSArray *placemarks, NSError *error)
          {
              
              if (error)
              {
                  STLogDebug(@"Geocode failed with error: %@", error);
                  return;
              }
              
              if (placemarks && placemarks.count > 0)
              {
                  CLPlacemark *placemark = placemarks[0];
                  
                  NSDictionary *addressDictionary = placemark.addressDictionary;
                  
                  NSString *street = [addressDictionary objectForKey:@"Street"];
                  NSString *city = [addressDictionary objectForKey:@"City"];
                  NSString *state = [addressDictionary objectForKey:@"Country"];
                  //NSString *Country = [addressDictionary  objectForKey:@"localized_address"];
                  
                  self.currentAdrees = [NSString stringWithFormat:@"%@, %@, %@", street, city, state];
                  
                  if (addressDictionary) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTrackLocation
                                                                          object:addressDictionary];
                  }
              }
          }];
     }];
}

#pragma mark - Menu Controller

- (MMDrawerController *)configureDrawerMenuWithLeft:(id)left andCenter:(id)center
{
    MMDrawerController *drawer = [[MMDrawerController alloc]
                                  initWithCenterViewController:center leftDrawerViewController:left];
    
    [drawer setMaximumRightDrawerWidth:300.0];
    [drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //[drawer setShowsShadow:NO];
    //[drawer.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern_gray"]]];
    [drawer setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        //percentVisible = 10;
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:50];
        //block = [MMDrawerVisualState slideVisualStateBlock];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    return drawer;
}

@end
