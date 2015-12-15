

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
#import "PackagePhotoViewController.h"
#import "TutorialViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define layerCornerRadius 2.5

typedef enum : NSUInteger {
    MenuCellTypeDeliveres,
    MenuCellTypePickupList,
    MenuCellTypeProfile,
    MenuCellTypeInfo,
    MenuCellTypeAbout,
    MEnuCellTypeTutorial,
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
        case MenuCellTypeProfile:   return NSLocalizedString(@"ctrl.menu.profile", nil);
        case MenuCellTypeInfo:      return NSLocalizedString(@"ctrl.menu.info", nil);
        case MenuCellTypeAbout:     return NSLocalizedString(@"ctrl.menu.about", nil);
        case MEnuCellTypeTutorial:  return NSLocalizedString(@"ctrl.menu.tutorial", nil);
        case MenuCellTypeLogout:    return NSLocalizedString(@"ctrl.menu.logout", nil);
        case MenuCellTypeSendNew:   return NSLocalizedString(@"ctrl.menu.sendNew", nil);
        default: return @"";
    }

}

+ (NSArray *)source {
    NSMutableArray *array = [NSMutableArray array];
    if (IS_COURIER_APP) {
        
        return @[@(MenuCellTypeDeliveres),
                 @(MenuCellTypeProfile),
                 @(MenuCellTypeInfo),
                 @(MEnuCellTypeTutorial),
                 @(MenuCellTypeLogout)];
        
    } else {
        
        return @[@(MenuCellTypePickupList),
                 @(MenuCellTypeProfile),
                 @(MenuCellTypeInfo),
                 @(MenuCellTypeAbout),
                 @(MEnuCellTypeTutorial),
                 @(MenuCellTypeLogout),
                 @(MenuCellTypeSendNew)];
    }
    return array;
}

@end


@interface LeftMenuViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (weak, nonatomic) IBOutlet UIButton *sendNew;
@property (weak, nonatomic) IBOutlet UIButton *callSupport;

@property (weak, nonatomic) IBOutlet UILabel *questions;

@property (nonatomic, strong) NSArray *source;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
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
    [self addCornerRadius:self.callSupport];
    
    self.questions.text = NSLocalizedString(@"ctrl.menu.questionsLabel", nil);

    self.sendNew.titleLabel.text = [Menu titleByType:MenuCellTypeSendNew];
    self.sendNew.tag = MenuCellTypeSendNew;
    
    [self.source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MenuCellType type = (MenuCellType)[obj integerValue];
        [[self.buttons objectAtIndex:idx] setTitle:[Menu titleByType:type] forState:0];
        [[self.buttons objectAtIndex:idx] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [[self.buttons objectAtIndex:idx] setTag:type];
    }];
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
        case MenuCellTypeProfile:   [self showProfile]; break;
        case MenuCellTypeInfo:      [self showInformation]; break;
        case MenuCellTypeAbout:     [self showAboutUs]; break;
        case MEnuCellTypeTutorial:  [self showTutorial]; break;
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

- (void) showTutorial
{
    TutorialViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
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
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }

    [self showMainScreen];
    [self showLoginView];
}

- (void) showCreateDeliveries
{
    PackagePhotoViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PackagePhotoViewController"];
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
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (IBAction)callSupportAction:(id)sender
{
    [[Server instance] supportPhoneSuccess:^(NSString *phoneNumber) {
        NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phoneNumber]];
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }
        else {
            [UIAlertView showAlertWithTitle:NSLocalizedString(@"generic.call", nil)
                                    message:NSLocalizedString(@"ctrl.regestration.call.incopatible", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"generic.ok", nil)
                          otherButtonTitles:nil, nil];
        }
    } failure:^(NSError *error, NSInteger code) {}];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
