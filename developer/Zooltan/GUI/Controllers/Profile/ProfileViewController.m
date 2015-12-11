//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "ProfileViewController.h"
#import "HistoryViewController.h"
#import "SocialManager.h"
#import "FromViewController.h"
#import "StatisticViewController.h"

#define delay 0.2f

#define keyboardHeight 260
#define durationAnimation 0.3f
#define layerCornerRadius 2.5
#define avatarCornerRadius 30
#define _borderWidth 2

@interface ProfileViewController () <UIScrollViewDelegate, TextFieldButtonDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet TextField *nameField;
@property (weak, nonatomic) IBOutlet TextField *phoneField;
@property (weak, nonatomic) IBOutlet TextField *oldPassField;
@property (weak, nonatomic) IBOutlet TextField *nPassField;
@property (weak, nonatomic) IBOutlet TextField *repeatPassField;

@property (nonatomic, weak) IBOutlet UIButton *saveBtn;
@property (nonatomic, weak) IBOutlet UIButton *fbBtn;

@property (nonatomic, weak) IBOutlet UIView *mainView;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImage;

@property (nonatomic, retain) UserModel *userModel;

@property (nonatomic, retain) PlaceModel *homeAddress;
@property (nonatomic, retain) PlaceModel *workAddress;

@property (weak, nonatomic) IBOutlet UILabel *homeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *workAddressLabel;

@property (nonatomic, weak) IBOutlet UILabel *navTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *homeAddressTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *workAdressTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *passwordTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *nPasswordTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *repeatPasswordTitleLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordLabelHeigh;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldHeigh;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldTop;
@property (strong, nonatomic) IBOutlet UIView *passwordButtomLineView;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getProfile];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lowerKeyboard)
                                                 name:closeKeyboard
                                               object:nil];
    
    [self setProfileData];
}

- (void)configureView
{
    [super configureView];
    
    self.nameField.tintColor = [Colors yellowColor];
    
//    [self setTextColor:self.homeAddressField];
//    [self setTextColor:self.workAddressField];
    [self setTextColor:self.phoneField];
    [self setTextColor:self.oldPassField];
    [self setTextColor:self.nPassField];
    [self setTextColor:self.repeatPassField];
    
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    self.oldPassField.secureTextEntry = YES;
    self.nPassField.secureTextEntry = YES;
    self.repeatPassField.secureTextEntry = YES;
    
    [self addCornerRadius:self.saveBtn radius:layerCornerRadius];
    [self addCornerRadius:self.fbBtn radius:self.fbBtn.height/2];
    self.fbBtn.layer.borderColor = [Colors whiteColor].CGColor;
    self.fbBtn.layer.borderWidth = _borderWidth;
    
    self.navTitleLabel.text = NSLocalizedString(@"ctrl.profile.navigation.title", nil);
    self.phoneNumberTitleLabel.text = NSLocalizedString(@"ctrl.profile.title.phonenumber", nil);
    self.homeAddressTitleLabel.text = NSLocalizedString(@"ctrl.profile.title.homeAddress", nil);
    self.workAdressTitleLabel.text = NSLocalizedString(@"ctrl.profile.title.workAddress", nil);
    self.passwordTitleLabel.text = NSLocalizedString(@"ctrl.profile.title.password", nil);
    self.nPasswordTitleLabel.text = NSLocalizedString(@"ctrl.profile.title.newPassword", nil);
    self.repeatPasswordTitleLabel.text = NSLocalizedString(@"ctrl.profile.title.repeatPassword", nil);
    self.saveBtn.titleLabel.text = NSLocalizedString(@"ctrl.profile.button.save", nil);
    
    self.saveBtn.backgroundColor = [Colors yellowColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.saveBtn.bottom+10);
    
    [self setProfileData];
}

- (void) addCornerRadius:(UIButton *) btn radius:(float) radius
{
    btn.layer.cornerRadius = radius;
    btn.clipsToBounds = YES;
}

- (void) setTextColor:(TextField *) textField
{
    textField.tintColor = [Colors yellowColor];
    textField.textColor = [Colors darkGrayColor];
    [textField setValue:[Colors darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void) addBottomLineInTextFild:(TextField *) textFild
{
    textFild.textColor = [UIColor lightGrayColor];
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, textFild.height+4, textFild.width, textFild.height);
    border.borderWidth = borderWidth;
    [textFild.layer addSublayer:border];
    textFild.clipsToBounds = YES;
    textFild.layer.masksToBounds = YES;
}

#pragma mark - set profile data
#pragma mark -

- (void) getProfile
{
    [[AppDelegate instance] showLoadingView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Server instance] getProfileSuccess:^(UserModel *userModel) {
            
            self.userModel = userModel;
            [self setProfileData];
            [[AppDelegate instance] hideLoadingView];
            
        } failure:^(NSError *error, NSInteger code) {
            [[AppDelegate instance] hideLoadingView];
            switch (code) {
                case 403: [Utilities showErrorMessage:NSLocalizedString(@"msg.error.403", nil) target:self]; break;
                default:
                    [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                    break;
            }
        }];
    });
}

- (void) setProfileData
{
    self.userModel = [[Settings instance] currentUser];
    
    self.homeAddress = [[Settings instance] homeAddress];
    self.workAddress = [[Settings instance] workAddress];
    
    self.nameField.text = self.userModel.name;
    self.phoneField.text = self.userModel.phone;
    
    [self setUserAvatarFromUrl:self.userModel.avatarURL];
    
    STLogDebug(@"homeAddress %@", self.homeAddress.formatted_address);
    STLogDebug(@"workAddress %@", self.workAddress.formatted_address);
    
    self.homeAddressLabel.text = self.homeAddress.formatted_address;
    self.workAddressLabel.text = self.workAddress.formatted_address;
    
    if (self.userModel.socialId && ![self.userModel.socialId isEqualToString:@""]) {
        self.fbBtn.enabled = NO;
        [self.fbBtn setTitle:@"CONNECTED WITH" forState:UIControlStateNormal];
    }
    
    if ([[[Settings instance] password] isEqualToString:self.userModel.socialId]) {
        self.oldPassField.enabled = NO;
        self.passwordButtomLineView.hidden = YES;
        self.passwordLabelHeigh.constant = 0;
        self.passwordLabelTop.constant = 0;
        self.passwordTextFieldHeigh.constant = 0;
        self.passwordTextFieldTop.constant = 0;
    }
    else {
        self.oldPassField.enabled = YES;
        self.passwordButtomLineView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.passwordLabelHeigh.constant = 40;
            self.passwordLabelTop.constant = 10;
            self.passwordTextFieldHeigh.constant = 40;
            self.passwordTextFieldTop.constant = 13;
        }];
    }
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) dissmisAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction) changeImageAction:(UIButton *)sender
{
    [self showActionSheet];
}

- (IBAction) editAction:(UIButton *)sender
{
    [self.nameField becomeFirstResponder];
}

- (IBAction) homeAdressAction:(id)sender
{
    [self lowerKeyboard];
    
    FromViewController *fromViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FromViewController"];
    fromViewController.addressType = HomeAddress;
    fromViewController.callController = Profile;
    [self.navigationController pushViewController:fromViewController animated:YES];
}

- (IBAction) workAdressAction:(id)sender
{
    [self lowerKeyboard];
    
    FromViewController *fromViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FromViewController"];
    fromViewController.addressType = WorkAddress;
    fromViewController.callController = Profile;
    [self.navigationController pushViewController:fromViewController animated:YES];
}

- (IBAction) saveAction:(UIButton *)sender
{
    [self lowerKeyboard];
    
    [self performBlock:^{
        [UIView animateWithDuration:durationAnimation
                         animations:^{
                             self.scrollView.contentSize = CGSizeMake(self.view.width, self.saveBtn.bottom+10);
                         }];
    } afterDelay:0];
    
    if ([self validateFields]) {
        [self updateProfile:[self _getUserData] success:nil];
    }
}

- (IBAction) fbAction:(UIButton *)sender
{
    [[SocialManager instance] autoriseInFBAndGetUseDataWithSuccess:^(UserModel *userModel) {
        
        UserModel *newUserModel = [self _getUserData];
        newUserModel.name = userModel.name;
        newUserModel.socialId = userModel.socialId;
        newUserModel.isFB = YES;
        
        [[Server instance] checkSocialId:newUserModel.socialId
                                 success:^(BOOL hasSocialId) {
                                     
                                     if (hasSocialId)
                                         [Utilities showAlertMessage:NSLocalizedString(@"msg.error.facebook", nil) target:self];
                                     
                                     else
                                         [self updateProfile:newUserModel success:^{
                                             [self updateImageProfileFromFb:userModel.avatarURL];
                                         }];
                                         
                                 } failure:^(NSError *error, NSInteger code) {}];
        
    } failure:^(NSError *error, NSString *status) {}];
}

- (IBAction)statisticAction:(UIButton *)sender
{
    StatisticViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:StatisticViewController.className];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - UIActionSheet
#pragma mark -

- (void) showActionSheet
{
    [self lowerKeyboard];
    
    UIActionSheet *pickerprofile_pic_sheet =
    [[UIActionSheet alloc] initWithTitle:@""
                                delegate:self
                       cancelButtonTitle:NSLocalizedString(@"generic.cancel", nil)
                  destructiveButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"ctrl.profile.action.selectImage", nil),NSLocalizedString(@"ctrl.profile.action.makePhoto", nil), nil];
    
    pickerprofile_pic_sheet.tag = 2;
    pickerprofile_pic_sheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self.view])
        [pickerprofile_pic_sheet showInView:self.view];
    else
        [pickerprofile_pic_sheet showInView:window];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [self performBlock:^{
            [self showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        } afterDelay:delay];
    }
    else if(buttonIndex == 1)
    {
        [self performBlock:^{
            [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];
        } afterDelay:delay];
    }
}

#pragma mark - UserAvatar
#pragma mark -

- (void) setUserAvatarFromUrl:(NSString *) url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    [self.avatarImage setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"emptyAvatar"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.avatarImage.image = image;
        [self setUserAvatarFromImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
}

- (void) setUserAvatarFromImage:(UIImage *) image
{
    self.avatarImage.image = image;
    self.avatarImage.layer.cornerRadius = avatarCornerRadius;
    self.avatarImage.clipsToBounds = YES;
}

- (void) updateImageProfile:(UIImage *) image
{
    [[AppDelegate instance] showLoadingView];
    
    [[Server instance] uploadImage:image
                           success:^(UserModel *userModel)
     {
         [[AppDelegate instance] hideLoadingView];
         [[Settings instance] setCurrentUser:userModel];
         [self setProfileData];
     } failure:^(NSError *error, NSInteger code)
     {
         [[AppDelegate instance] hideLoadingView];
         switch (code) {
             case 409:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                 break;
             case 403:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.403", nil) target:self];
                 break;
                 
             default:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.enteredData", nil) target:self];
                 break;
         }
     }];
}

- (void) updateImageProfileFromFb:(NSString *) path
{
    [[AppDelegate instance] showLoadingView];
    
    [[Server instance] uploadImageFromPath:path
                                   success:^(UserModel *userModel)
     {
         [[AppDelegate instance] hideLoadingView];
         [[Settings instance] setCurrentUser:userModel];
         [self setProfileData];
     } failure:^(NSError *error, NSInteger code)
     {
         [[AppDelegate instance] hideLoadingView];
         switch (code) {
             case 409:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                 break;
             case 403:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.403", nil) target:self];
                 break;
                 
             default:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.enteredData", nil) target:self];
                 break;
         }
     }];
}

- (UIActivityIndicatorView *) hideSpinnerAnimatedInView:(UIActivityIndicatorView *) _spiner imageView:(UIImageView *) imageView hide:(BOOL) hide
{
    if (!hide)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        spinner.frame = CGRectMake(imageView.frame.size.width/2-15, imageView.frame.size.height/2-15, 30, 30);
        spinner.backgroundColor = [UIColor clearColor];
        [imageView addSubview:spinner];
        [spinner startAnimating];
        spinner.hidden = NO;
        
        return spinner;
    }
    else
    {
        [_spiner stopAnimating];
        _spiner.hidden = YES;
    }
    return nil;
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark -

-(void)showImagePickerController:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self updateImageProfile:image];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - update Profile
#pragma mark -

- (void)updateProfile:(UserModel *)userModel
              success:(void (^)(void))success
{
    [[AppDelegate instance] showLoadingView];
    
    PlaceModel *homeAddress = [[Settings instance] homeAddress];
    PlaceModel *workAddress = [[Settings instance] workAddress];
    
    if (!homeAddress.formatted_address || homeAddress.formatted_address.length <= 0)
        homeAddress = nil;
    
    if (!workAddress.formatted_address || workAddress.formatted_address.length <= 0)
        workAddress = nil;
    
    [[Server instance] updateProfile:userModel
                         homeAddress:homeAddress
                         workAddress:workAddress
                             success:^(UserModel *userModel)
     {
         [[Settings instance] setCurrentUser:userModel];
         
         if (self.nPassField.text.length > 0 && ![self.nPassField.text isEqualToString:@""])
             [[Settings instance] setPassword:self.nPassField.text];
         
         self.oldPassField.text = @"";
         self.nPassField.text = @"";
         self.repeatPassField.text = @"";
         
         [self performBlock:^{
             [self setProfileData];
         } afterDelay:delay];
         
         if (success) {
             success();
         }
         
         [[AppDelegate instance] hideLoadingView];
         
     } failure:^(NSError *error, NSInteger code) {
         [[AppDelegate instance] hideLoadingView];
         switch (code) {
             case 409:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                 break;
             case 403:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.403", nil) target:self];
                 break;
                 
             default:
                 [Utilities showAlertMessage:NSLocalizedString(@"msg.error.enteredData", nil) target:self];
                 break;
         }
     }];
}

#pragma mark - validate Fields
#pragma mark -

- (BOOL) validateFields {
    STLogMethod;
    
    if (self.nameField.text.length == 0) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.name", nil) target:self];
        return NO;
    }
    else if (self.nameField.text.length < kMinCharactersLength) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredNameCharacters", nil) target:self];
        return NO;
    }
    else if (self.phoneField.text.length == 0) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.phoneNumber", nil) target:self];
        return NO;
    }
    else if (self.phoneField.text.length < 13) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPhoneNumberCharacters", nil) target:self];
        return NO;
    }
    else if (self.oldPassField.text.length > 0 && ![self.oldPassField.text isEqualToString:[[Settings instance] password]]) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredOldPassword", nil) target:self];
        return NO;
    }
    else if ([[[Settings instance] password] isEqualToString:self.userModel.socialId]) {
        if (self.nPassField.text.length > 0 && self.repeatPassField.text.length == 0) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.repeatPassword", nil) target:self];
            return NO;
        }
        else if (self.nPassField.text.length == 0 && self.repeatPassField.text.length > 0) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.newPassword", nil) target:self];
            return NO;
        }
        else if (![self.nPassField.text isEqualToString:self.repeatPassField.text]) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredDifferentPasswords" , nil) target:self];
            return NO;
        }
    }
    else if (![[[Settings instance] password] isEqualToString:self.userModel.socialId]) {
        if (self.nPassField.text.length > 0 && self.repeatPassField.text.length == 0) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.repeatPassword", nil) target:self];
            return NO;
        }
        else if (self.repeatPassField.text.length > 0 && self.nPassField.text.length == 0) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.newPassword", nil) target:self];
            return NO;
        }
        else if (self.nPassField.text.length > 0 && self.repeatPassField.text.length > 0 && self.oldPassField.text.length == 0) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.oldPassword", nil) target:self];
            return NO;
        }
        else if (![self.nPassField.text isEqualToString:self.repeatPassField.text]) {
            [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredDifferentPasswords" , nil) target:self];
            return NO;
        }
    }
    return YES;
}

- (void) setTextCololInField:(TextField *) textfild colol:(UIColor *) color
{
    [UIView animateWithDuration:durationAnimation
                     animations:^{
                         textfild.textColor = color;
                         [textfild setValue:color forKeyPath:@"_placeholderLabel.textColor"];
                     }];
}

- (void) lowerKeyboard
{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.oldPassField resignFirstResponder];
    [self.nPassField resignFirstResponder];
    [self.repeatPassField resignFirstResponder];
}

- (UserModel *) _getUserData
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UserModel *userModel = [[UserModel alloc] init];
    userModel.name = self.nameField.text;
    userModel.phone = phone;
    
    if (self.oldPassField.text.length != 0 && ![self.oldPassField.text isEqualToString:@""])
        userModel.password = self.oldPassField.text;
    else
        userModel.password = self.userModel.socialId;
    
    if (self.nPassField.text.length != 0 && ![self.nPassField.text isEqualToString:@""])
        userModel.nPassword = self.nPassField.text;
    
    return userModel;
}

#pragma mark - UITextFieldDelegate
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextCololInField:self.phoneField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.oldPassField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.nPassField colol:[UIColor darkGrayColor]];
    [self setTextCololInField:self.repeatPassField colol:[UIColor darkGrayColor]];
    
    if (textField == self.phoneField) {
        if (textField.isEmpty)
            textField.text = [NSString stringWithFormat:@"%@ ", kPhoneCodePrefix];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.phoneField == textField)
    {
        return [[Phone instance] configurePhoneNumberFromTextField:textField
                                             withCharactersInRange:range
                                                            string:string];
    }
    
    return true;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
