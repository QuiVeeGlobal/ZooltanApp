//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "CreateViewController.h"
#import "RegistrationViewController.h"
#import "RecoveryPasswordViewController.h"
#import "DLRadioButton.h"
#import "FromViewController.h"
#import "AFNetworking.h"
#import "ContactsViewController.h"
#import "PhotoViewerViewController.h"
#import "PackagePhotoViewController.h"
#import "HistoryViewController.h"
#import "TrakingViewController.h"
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>

#define METERS_PER_MILE 1609.344
#define layerCornerRadius 2.5
#define durationAnimation 0.3f
#define keyboardHeight 260
#define REQUEST self.manager

@interface CreateViewController () <TextFieldButtonDelegate, UITextFieldDelegate, UIScrollViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;

@property (weak, nonatomic) IBOutlet TextField *receiverNameField;
@property (weak, nonatomic) IBOutlet TextField *receiverNumberField;
@property (weak, nonatomic) IBOutlet TextField *commentsTextField;

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoAttachedLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;

@property (weak, nonatomic) IBOutlet UIView *mapBGView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView *packageIcon;
@property (strong, nonatomic) IBOutlet UILabel *packageWeightLabel;

@property (strong, nonatomic) UIImage *packageImage;

@property (strong, nonatomic) NSString *packageSize;

@property (nonatomic, retain) PlaceModel *fromAddress;
@property (nonatomic, retain) PlaceModel *toAddress;

@property (nonatomic, retain) GMSMarker *fromMarker;
@property (nonatomic, retain) GMSMarker *toMarker;

@property (nonatomic, strong) IBOutlet GMSMapView *mapView_;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.packageImage = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"package.jpg"]];
    
    self.packageSize = @"LETTER";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lowerKeyboard)
                                                 name:closeKeyboard
                                               object:nil];

    [self setOrderData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.receiverNameField.text.length <= 0)
        [self.receiverNameField becomeFirstResponder];
    
    else if (self.receiverNameField.text.length > 0 && self.receiverNumberField.text.length <= 0)
        [self.receiverNumberField becomeFirstResponder];
    
    else if (self.receiverNameField.text.length > 0 && self.receiverNumberField.text.length > 0 && self.fromAddressLabel.text.length <= 0)
        [self performSelector:@selector(fromAdressAction:) withObject:nil afterDelay:0.5];
    
    else if (self.fromAddressLabel.text.length > 0 && self.toAddressLabel.text.length <= 0)
        [self performSelector:@selector(toAdressAction:) withObject:nil afterDelay:0.5];
    
    else if (self.toAddressLabel.text.length > 0 && self.fromAddressLabel.text.length <= 0)
        [self performSelector:@selector(fromAdressAction:) withObject:nil afterDelay:0.5];
    
    else if ([self.toAddressLabel.text isEqualToString:self.fromAddressLabel.text]) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredSameAdresses", nil) target:self];
        [self performSelector:@selector(toAdressAction:) withObject:nil afterDelay:0.5];
    }
    
    else if (self.receiverNameField.text.length > 0 && self.receiverNumberField.text.length > 0 && self.fromAddressLabel.text.length > 0 && self.toAddressLabel.text.length > 0 && self.commentsTextField.text.length <= 0)
        [self.commentsTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [kUserDefaults setObject:self.receiverNameField.text forKey:@"reciever_name"];
    [kUserDefaults setObject:self.receiverNumberField.text forKey:@"reciever_number"];
    [kUserDefaults setObject:self.commentsTextField.text forKey:@"comments"];
    [kUserDefaults synchronize];
}

- (void) setOrderData
{
    self.receiverNameField.text = [kUserDefaults objectForKey:@"reciever_name"];
    self.receiverNumberField.text = [kUserDefaults objectForKey:@"reciever_number"];
    self.commentsTextField.text = [kUserDefaults objectForKey:@"comments"];
    
    [self setTextCololInField:self.receiverNameField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.receiverNumberField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.commentsTextField colol:[UIColor darkGrayColor]];
    
    self.fromAddress = [[Settings instance] fromAddress];
    self.toAddress = [[Settings instance] toAddress];
    
    STLogDebug(@"fromAddress %@", self.fromAddress.formatted_address);
    STLogDebug(@"toAddress %@", self.toAddress.formatted_address);
    
    self.fromAddressLabel.text = self.fromAddress.formatted_address;
    self.toAddressLabel.text = self.toAddress.formatted_address;
    
    if (self.fromAddress.formatted_address != nil && self.toAddress.formatted_address != nil)
        [self showRoute];
    
    if (self.contact) {
        self.receiverNameField.text = self.contact.fullName;
        
        if ([self.contact.phonesValues count] > 0) {
            NSString *phone = self.contact.phonesValues[0];
            phone = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
            self.receiverNumberField.text = phone;
        }
            //self.receiverNumberField.text = self.contact.phonesValues[0];
        
        [self setTextCololInField:self.receiverNameField colol:[UIColor darkGrayColor]];
        [self setTextCololInField:self.receiverNumberField colol:[UIColor darkGrayColor]];
    }
    
    if (!self.packageImage) {
        self.photoAttachedLabel.text = NSLocalizedString(@"ctrl.create.noPhotoAttached.title", nil);
        self.photoViewBtn.titleLabel.text = NSLocalizedString(@"ctrl.create.button.addPhoto", nil);
        self.photoViewBtn.hidden = YES;
        self.photoViewBtn.enabled = NO;
        self.addPhotoBtn.hidden = NO;
        self.addPhotoBtn.enabled = YES;
    } else {
        self.addPhotoBtn.hidden = YES;
        self.addPhotoBtn.enabled = NO;
    }
}

- (void)configureView
{
    [super configureView];
    
    [self setMapView];
    
    self.receiverNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.receiverNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.commentsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.receiverNameField.tintColor = [Colors yellowColor];
    self.receiverNumberField.tintColor = [Colors yellowColor];
    self.commentsTextField.tintColor = [Colors yellowColor];
    
    self.segmentedControl.tintColor = [Colors yellowColor];
    
    [self addCornerRadius:self.sendBtn radius:layerCornerRadius];
    
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.create.segmented.title1", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.create.segmented.title2", nil) forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.create.segmented.title3", nil) forSegmentAtIndex:2];
    
    self.navItem.title                 = NSLocalizedString(@"ctrl.create.navigation.title", nil);
    self.mainTitleLabel.text           = NSLocalizedString(@"ctrl.create.mainlabel.title", nil);
    self.receiverNameLabel.text        = NSLocalizedString(@"ctrl.create.receiverName.title", nil);
    self.receiverNumberLabel.text      = NSLocalizedString(@"ctrl.create.receiverNumber.title", nil);
    self.fromAddressLabel.text         = NSLocalizedString(@"ctrl.create.from.title", nil);
    self.toAddressLabel.text           = NSLocalizedString(@"ctrl.create.to.title", nil);
    self.commentsLabel.text            = NSLocalizedString(@"ctrl.create.comments.title", nil);
    self.commentsTextField.placeholder = NSLocalizedString(@"ctrl.create.placeholder.comments", nil);
    self.sendBtn.titleLabel.text       = NSLocalizedString(@"ctrl.create.button.request", nil);
    self.photoAttachedLabel.text       = NSLocalizedString(@"ctrl.create.photoAttached.title", nil);
    self.photoViewBtn.titleLabel.text  = NSLocalizedString(@"ctrl.create.button.photoView", nil);
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
}

- (void) addCornerRadius:(UIButton *) btn radius:(float) radius
{
    btn.layer.cornerRadius = radius;
    btn.clipsToBounds = YES;
}

#pragma mark - set Googl map
#pragma mark -

- (void) setMapView
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.mapView_.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude zoom:15];
    self.mapView_.camera = camera;
    self.mapView_.myLocationEnabled = YES;
    //self.mapView_.userInteractionEnabled = NO;
    self.mapView_.settings.zoomGestures = NO;
    self.mapView_.settings.scrollGestures = NO;
}

- (void) showRoute
{
    CLLocationCoordinate2D fromLoc = CLLocationCoordinate2DMake(self.fromAddress.location.latitude, self.fromAddress.location.longitude);
    CLLocationCoordinate2D toLoc = CLLocationCoordinate2DMake(self.toAddress.location.latitude, self.toAddress.location.longitude);
    
    self.fromMarker = [[GMSMarker alloc] init];
    self.toMarker = [[GMSMarker alloc] init];
    
    self.fromMarker.position = fromLoc;
    self.toMarker.position = toLoc;
    
    self.fromMarker.icon = [UIImage imageNamed:@"pickup_dot"];
    self.fromMarker.map = self.mapView_;
    
    self.toMarker.icon = [UIImage imageNamed:@"reciver_dot"];
    self.toMarker.map = self.mapView_;
    
    CLLocation *from = [[CLLocation alloc] initWithLatitude:self.fromAddress.location.latitude longitude:self.fromAddress.location.longitude];
    CLLocation *to = [[CLLocation alloc] initWithLatitude:self.toAddress.location.latitude longitude:self.toAddress.location.longitude];
    
    OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginLocation:from andDestinationLocation:to];
    OCDirectionsAPIClient *client = [OCDirectionsAPIClient new];
    [request setTravelMode:OCDirectionsRequestTravelModeDriving];
    
    [client directions:request response:^(OCDirectionsResponse *response,  NSError *error) {
        
        if (error)
            return;
        
        if (response.status != OCDirectionsResponseStatusOK)
            return;
        
        NSString *points = response.dictionary[@"routes"][0][@"overview_polyline"][@"points"];
        
        //        GMSPolyline *polyPath       = [GMSPolyline polylineWithPath:[GMSPath pathFromEncodedPath:points]];
        //        polyPath.strokeColor        = [UIColor blueColor];
        //        polyPath.strokeWidth        = 3.0f;
        //        polyPath.map                = self.mapView_;
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:[GMSPath pathFromEncodedPath:points]];
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(70, 70, 70, 70)];
        [self.mapView_ moveCamera:update];
        
        //NSLog(@"RESPONSE %@", response.dictionary);
        
    }];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if (marker == self.fromMarker) {
        [self fromAdressAction:nil];
    }
    if (marker == self.toMarker) {
        [self toAdressAction:nil];
    }
    return YES;
}

#pragma mark - IBAction
#pragma mark -

- (void) backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)segmentedAction:(id)sender
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.packageIcon.image = [UIImage imageNamed:@"LetterPackageIcon"];
            self.packageWeightLabel.text = NSLocalizedString(@"ctrl.create.package.weight.letter", nil);
            self.packageSize = @"LETTER";
            break;
            
        case 1:
            self.packageIcon.image = [UIImage imageNamed:@"SmallPackageIcon"];
            self.packageWeightLabel.text = NSLocalizedString(@"ctrl.create.package.weight.small", nil);
            self.packageSize = @"SMALL_BOX";
            break;
            
        case 2:
            self.packageIcon.image = [UIImage imageNamed:@"BigPackageIcon"];
            self.packageWeightLabel.text = NSLocalizedString(@"ctrl.create.package.weight.big", nil);
            self.packageSize = @"BIG_BOX";
            break;
            
        default:
            break;
    }
}
- (IBAction)addContactAction:(id)sender
{
    ContactsViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactsViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
    [self lowerKeyboard];
}

- (IBAction)fromAdressAction:(id)sender
{
    [self lowerKeyboard];
    
    FromViewController *fromViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FromViewController"];
    fromViewController.addressType = FromAddress;
    fromViewController.callController = Create;
    [self.mapView_ clear];
    
    [self.navigationController pushViewController:fromViewController animated:YES];
}

- (IBAction)toAdressAction:(id)sender
{
    [self lowerKeyboard];
    
    FromViewController *fromViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FromViewController"];
    fromViewController.addressType = ToAddress;
    fromViewController.callController = Create;
    fromViewController.contact = self.contact;
    [self.mapView_ clear];
    
    [self.navigationController pushViewController:fromViewController animated:YES];
}

- (IBAction)photoViewAction:(id)sender
{
    PhotoViewerViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewerViewController"];
    [self.navigationController presentViewController:ctr animated:YES completion:nil];
    [self lowerKeyboard];
}

- (IBAction)addPhotoAction:(id)sender
{
    PackagePhotoViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PackagePhotoViewController"];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
    
    [self lowerKeyboard];
}

- (IBAction)sendOrderAction:(id)sender
{
    if ([self validateFields])
        [self sendOrder];
}

- (void)sendOrder
{
    [[AppDelegate instance] showLoadingView];
    
    CLLocation *fromLoc = [[CLLocation alloc] initWithLatitude:self.fromAddress.location.latitude longitude:self.fromAddress.location.longitude];
    CLLocation *toLoc = [[CLLocation alloc] initWithLatitude:self.toAddress.location.latitude longitude:self.toAddress.location.longitude];
    CLLocationDistance orderDist = [fromLoc distanceFromLocation:toLoc]/1000;
    
    NSString *fromLongitude = [NSString stringWithFormat:@"%f", self.fromAddress.location.longitude];
    NSString *fromLatitude  = [NSString stringWithFormat:@"%f", self.fromAddress.location.latitude];
    NSString *toLongitude   = [NSString stringWithFormat:@"%f", self.toAddress.location.longitude];
    NSString *toLatitude    = [NSString stringWithFormat:@"%f", self.toAddress.location.latitude];
    NSString *distance      = [NSString stringWithFormat:@"%f", orderDist];
    NSString *phone         = [self.receiverNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *comment       = self.commentsTextField.text;
    UIImage  *packageImage  = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"package.jpg"]];
    NSData   *imadeData     = UIImageJPEGRepresentation(packageImage, 0.5);
    
    STLogDebug(@"STEP 1");
    
    NSDictionary *param = @{@"size"         : NIL_TO_NULL(self.packageSize),
                            @"receiver"     : NIL_TO_NULL(self.receiverNameField.text),
                            @"phone"        : NIL_TO_NULL(phone),
                            @"from_address" : NIL_TO_NULL(self.fromAddressLabel.text),
                            @"from_lon"     : NIL_TO_NULL(fromLongitude),
                            @"from_lat"     : NIL_TO_NULL(fromLatitude),
                            @"to_address"   : NIL_TO_NULL(self.toAddressLabel.text),
                            @"to_lon"       : NIL_TO_NULL(toLongitude),
                            @"to_lat"       : NIL_TO_NULL(toLatitude),
                            @"distance"     : NIL_TO_NULL(distance),
                            @"comment"      : NIL_TO_NULL(comment)};
    
    STLogDebug(@"STEP 2");
    
    STLogDebug(@"param___: %@",param);
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    
    [REQUEST POST:@"/client/order/create" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"formData %@", formData);
        
        if (imadeData) {
            [formData appendPartWithFileData:imadeData
                                        name:@"image"
                                    fileName:@"package.jpg"
                                    mimeType:@"image/jpg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AppDelegate instance] hideLoadingView];
        STLogSuccess(@"/client/order/create RESPONSE: %@",responseObject);
        NSLog(@"statusCode %zd", operation.response.statusCode);
        
        __block OrderModel *order = [[OrderModel alloc] initWithDictionary:responseObject];
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            [[Server instance] viewOrder:order success:^{
                [[AppDelegate instance] hideLoadingView];
                TrakingViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TrakingViewController"];
                [self.navigationController pushViewController:ctr animated:YES];
                ctr.order = order;
                [self clearOrderData];
                
            } failure:^(NSError *error, NSInteger code) {
                [[AppDelegate instance] hideLoadingView];
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AppDelegate instance] hideLoadingView];
        STLogSuccess(@"/client/order/create FAILURE: %@",operation.responseString);
    }];
}

- (void)clearOrderData
{
    self.receiverNameField.text = @"";
    self.receiverNumberField.text = @"";
    self.commentsTextField.text = @"";
    self.fromAddressLabel.text = @"";
    self.toAddressLabel.text = @"";
    
    [kUserDefaults removeObjectForKey:@"reciever_name"];
    [kUserDefaults removeObjectForKey:@"reciever_number"];
    [kUserDefaults removeObjectForKey:@"settings_fromAddress"];
    [kUserDefaults removeObjectForKey:@"settings_toAddress"];
    [kUserDefaults removeObjectForKey:@"comments"];
    [kUserDefaults synchronize];
}

- (void)lowerKeyboard
{
    [self.receiverNameField resignFirstResponder];
    [self.receiverNumberField resignFirstResponder];
    [self.commentsTextField resignFirstResponder];
}

#pragma mark - validate Fields
#pragma mark -

- (BOOL)validateFields
{
    if (self.receiverNameField.text.length <= 0)
    {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredReciverName", nil) target:self];
        return NO;
    }
    else if (self.receiverNumberField.text.length <= 0)
    {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredReciverPhone", nil) target:self];
        return NO;
    }
    else if (self.fromAddressLabel.text.length <= 0)
    {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredFromAddress", nil) target:self];
        return NO;
    }
    else if (self.toAddressLabel.text.length <= 0)
    {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredToAddress", nil) target:self];
        return NO;
    }
    else if ([self.fromAddressLabel.text isEqualToString:self.toAddressLabel.text]) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredSameAdresses", nil) target:self];
        return NO;
    }
    else if (self.receiverNumberField.text.length < 15) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPhoneNumberCharacters", nil) target:self];
        return NO;
    }
    
    return YES;
}

- (void)setTextCololInField:(TextField *)textField colol:(UIColor *)color
{
    [UIView animateWithDuration:durationAnimation
                     animations:^{
                         textField.textColor = color;
                         [textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
                     }];
}

#pragma mark - UITextFieldDelegate
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextCololInField:self.receiverNameField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.receiverNumberField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.commentsTextField colol:[UIColor darkGrayColor]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.receiverNumberField == textField) {
        [self lowerKeyboard];
        if (self.fromAddressLabel.text.length <= 0)
            [self performSelector:@selector(fromAdressAction:) withObject:nil afterDelay:0.5];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.receiverNumberField == textField)
    {
        return [[Phone instance] configurePhoneNumberFromTextField:textField
                                             withCharactersInRange:range
                                                            string:string];
    }
    
    return true;
}

#pragma mark - POST methods

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[Constants baseURL]]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"application/json"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        _manager.responseSerializer = jsonResponseSerializer;
    }
    
    return _manager;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
