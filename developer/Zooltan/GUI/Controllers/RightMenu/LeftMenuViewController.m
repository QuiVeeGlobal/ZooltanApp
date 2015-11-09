

#import "LeftMenuViewController.h"
#import "AuthorizationViewController.h"
#import "CreateViewController.h"
#import "ExpanceViewController.h"
#import "ProfileViewController.h"
#import "InformationViewController.h"
#import "AboutUsViewController.h"
#import "HistoryViewController.h"
#import "CourierHistoryViewController.h"
#import "PackageViewController.h"
#import "CourierHistoryViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define layerCornerRadius 2.5

typedef enum : NSUInteger {
    MenuCellTypeDeliveres,
    MenuCellTypePickupList,
    MenuCellTypeExpense,
    MenuCellTypeProfile,
    MenuCellTypeInfo,
    MenuCellTypeAbout,
    MenuCellTypeLogout,
    MenuCellTypeSendNew,
} MenuCellType;

@interface Menu : NSObject
+ (NSArray *)source;
+ (NSString *)titleByType:(MenuCellType)type;

@end

@implementation Menu

+ (NSString *)titleByType:(MenuCellType)type {
    switch (type) {
        case MenuCellTypeDeliveres: return NSLocalizedString(@"ctrl.menu.deliveres", nil);
        case MenuCellTypePickupList:return NSLocalizedString(@"ctrl.menu.pickupList", nil);
        case MenuCellTypeExpense:   return NSLocalizedString(@"ctrl.menu.expense", nil);
        case MenuCellTypeProfile:   return NSLocalizedString(@"ctrl.menu.profile", nil);
        case MenuCellTypeInfo:      return NSLocalizedString(@"ctrl.menu.info", nil);
        case MenuCellTypeAbout:     return NSLocalizedString(@"ctrl.menu.about", nil);
        case MenuCellTypeLogout:    return NSLocalizedString(@"ctrl.menu.logout", nil);
        case MenuCellTypeSendNew:   return NSLocalizedString(@"ctrl.menu.sendNew", nil);
        default: return @"";
    }

}

+ (NSArray *)source {
    NSMutableArray *array = [NSMutableArray array];
    if (IS_COURIER_APP) {
        
        return @[@(MenuCellTypeDeliveres),
                 @(MenuCellTypeExpense),
                 @(MenuCellTypeProfile),
                 @(MenuCellTypeInfo),
                 @(MenuCellTypeAbout),
                 @(MenuCellTypeLogout),
                 @(MenuCellTypeDeliveres)];
        
    } else {
        
        return @[@(MenuCellTypePickupList),
                 @(MenuCellTypeDeliveres),
                 @(MenuCellTypeProfile),
                 @(MenuCellTypeInfo),
                 @(MenuCellTypeLogout),
                 @(MenuCellTypeDeliveres)];
    }
    return array;
}

@end


@interface LeftMenuViewController ()
{}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIButton *sendNew;

@property (nonatomic, strong) NSArray *source;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.source = [Menu source];
    self.view.backgroundColor = [Colors yellowColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCenterView)
                                                 name:showCenterView
                                               object:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[super getUserData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
}

#pragma mark - configureView and UI
#pragma mark -

- (void)configureView
{
    [super configureView];
    
    [self addCornerRadius:self.sendNew];

    self.sendNew.titleLabel.text = [Menu titleByType:MenuCellTypeSendNew];
    self.sendNew.tag = MenuCellTypeSendNew;
    
    [self.source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MenuCellType type = (MenuCellType)[obj integerValue];
        [[self.buttons objectAtIndex:idx] setTitle:[Menu titleByType:type] forState:0];
        [[self.buttons objectAtIndex:idx] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [[self.buttons objectAtIndex:idx] setTag:type];
    }];
//    for (int i = 0; i < self.buttons.count; i++)
//    {
//        NSString *titleString = [NSString stringWithFormat:@"ctrl.menu.button.0%zd", i+1];
//        [[self.buttons objectAtIndex:i] setTitle:NSLocalizedString(titleString, nil) forState:0];
//        [[self.buttons objectAtIndex:i] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
//    }
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
}

- (void) setCenterView
{
    STLogMethod;
    
    [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController
                                   withCloseAnimation:YES
                                           completion:^(BOOL finished) {}];
    
}

#pragma mark - Login
#pragma mark -

- (void) showLoginView
{
    STLogMethod;
    
    AuthorizationViewController *authorizationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthorizationViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authorizationViewController];
    navigationController.navigationBar.hidden = YES;
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

#pragma mark - UIGestureRecognizer
#pragma mark -

- (void)backgroundTap:(UIGestureRecognizer*) gesture
{
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) catgoryAction:(UIButton *)sender
{
    MenuCellType type = (MenuCellType)sender.tag;
    
    switch (type) {
        case MenuCellTypeDeliveres: [self showDelivers]; break;
        case MenuCellTypePickupList:[self showDelivers]; break;
        case MenuCellTypeExpense:   [self showExpense];  break;
        case MenuCellTypeProfile:   [self showProfile]; break;
        case MenuCellTypeInfo:      [self showInformation]; break;
        case MenuCellTypeAbout:     [self showAboutUs]; break;
        case MenuCellTypeLogout:    [self logout]; break;
        case MenuCellTypeSendNew:   [self showCreateDeliveries]; break;
        default: break;
    }
}

- (void) showDelivers
{
    if (IS_CUSTOMER_APP) {
        HistoryViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
        [self openController:ctr];
    }
    else {
        CourierHistoryViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"CourierHistoryViewController"];
        [self openController:ctr];
    }
}

- (void) showExpense
{
    ExpanceViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpanceViewController"];
    [self openController:ctr];
}

- (void) showProfile
{
    ProfileViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self openController:ctr];
}

- (void) showInformation
{
    InformationViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    [self openController:ctrl];
}

- (void) showAboutUs
{
    AboutUsViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
    [self openController:ctr];
}

- (void) logout
{
    UserModel *userModel = [UserModel new];
    PlaceModel *pM = [PlaceModel new];
    
    [[Settings instance] setToken:@""];
    [[Settings instance] setCurrentUser:userModel];
    
    [[Settings instance] setHomeAddress:pM];
    [[Settings instance] setWorkAddress:pM];

    if (IS_CUSTOMER_APP) {
        [FBSession.activeSession closeAndClearTokenInformation];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }

    [self showMainScreen];
    [self showLoginView];
}

- (void) showCreateDeliveries
{
    CreateViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    [self openController:ctr];
}

- (void) showMainScreen
{
    if (IS_CUSTOMER_APP) {
        MainViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self openController:ctr];
    }
    else {
        CourierHistoryViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"CourierHistoryViewController"];
        [self openController:ctr];
    }
}

- (void) openController:(UIViewController *) ctr
{
    if (!ctr) {
        return;
    }
    
    BaseNavigationCtrl *navCtr = [[AppDelegate instance] navigation];
    [navCtr setViewControllers:@[ctr] animated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:clearOrder object:nil];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
//    
//    [self.mm_drawerController setCenterViewController:navCtr
//                                   withCloseAnimation:YES
//                                           completion:^(BOOL finished) {}];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
