//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "AuthorizationViewController.h"
#import "RegistrationViewController.h"
#import "RecoveryPasswordViewController.h"
#import "CompleteRegistrationViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SocialManager.h"

#define layerBorderWidth 1.5
#define layerCornerRadius 2.5
#define bottomLineWidth 1
#define duration 1
#define durationAnomation 0.3f
#define keyboardHeight 260

@interface AuthorizationViewController () <TextFieldButtonDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@property (weak, nonatomic) IBOutlet TextField *phoneField;
@property (weak, nonatomic) IBOutlet TextField *passField;

@property (nonatomic, weak) IBOutlet UIButton *forgotPassBtn;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, weak) IBOutlet UIButton *registrationBtn;
@property (nonatomic, weak) IBOutlet UIButton *enterWithFB;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLaunch"])
//        [self showTutorialView];
}

- (void)configureView
{
    [super configureView];
    
    if (IS_COURIER_APP)
        self.enterWithFB.hidden = YES;
    
#ifdef DEBUG
    if (IS_CUSTOMER_APP) {
        self.phoneField.text = @"+380 93 2664 344";
        self.passField.text = @"qwerty";
    } else {
        self.phoneField.text = @"+380 93 2664 343";
        self.passField.text = @"qwerty";
    }
#endif
    
    if (![deteckScreen() isEqualToString:@"iPhone3,1"] && ![deteckScreen() isEqualToString:@"iPhone3,2"] && ![deteckScreen() isEqualToString:@"iPhone3,3"])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"ctrl.authorization.button.forgot", nil)
                                                                                 attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}]];
        
        self.forgotPassBtn.titleLabel.attributedText = attributedString;
    }
    
    self.mainLabel.text = NSLocalizedString(@"ctrl.authorization.description", nil);
    self.phoneField.placeholder = NSLocalizedString(@"ctrl.authorization.placeholder.phone", nil);
    self.passField.placeholder = NSLocalizedString(@"ctrl.authorization.placeholder.password", nil);
    self.loginBtn.titleLabel.text = NSLocalizedString(@"ctrl.authorization.button.login", nil);
    self.registrationBtn.titleLabel.text = NSLocalizedString(@"ctrl.authorization.button.regestration", nil);
    self.enterWithFB.titleLabel.text = NSLocalizedString(@"ctrl.authorization.button.fb", nil);
    
    [self setBottomLine:self.phoneField];
    [self setBottomLine:self.passField];
    
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.passField.secureTextEntry = YES;
    self.passField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.registrationBtn.layer.borderColor = [Colors yellowColor].CGColor;
    self.registrationBtn.layer.borderWidth = layerBorderWidth;
    self.registrationBtn.titleLabel.textColor = [Colors yellowColor];
    
    self.enterWithFB.backgroundColor = [Colors fbBlueColor];
    
    self.loginBtn.backgroundColor = [Colors yellowColor];
    
    [self addCornerRadius:self.registrationBtn];
    [self addCornerRadius:self.loginBtn];
    [self addCornerRadius:self.enterWithFB];
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
}

- (void) setBottomLine:(TextField *) textField
{
    textField.tintColor = [Colors yellowColor];
    
    textField.textColor = [Colors whiteColor];
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CALayer *bottomLine = [CALayer layer];
    CGFloat borderWidth = bottomLineWidth;
    bottomLine.borderColor = [Colors yellowColor].CGColor;
    bottomLine.frame = CGRectMake(0, textField.height-borderWidth, textField.width, textField.height);
    bottomLine.borderWidth = borderWidth;
    [textField.layer addSublayer:bottomLine];
    textField.clipsToBounds = YES;
    textField.layer.masksToBounds = YES;
    textField.bottomLine = bottomLine;
}

#pragma mark - DeteckScreen
#pragma mark -

NSString* deteckScreen()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) forgotPasswordAction:(UIButton *)sender
{
    [self lowerKeyboard];
    
    RecoveryPasswordViewController *recoveryPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoveryPasswordViewController"];
    [self.navigationController pushViewController:recoveryPasswordViewController animated:YES];
}

- (IBAction) registrationAction:(UIButton *)sender
{
    [self lowerKeyboard];
    
    if (IS_CUSTOMER_APP) {
        RegistrationViewController *registrationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
        [self.navigationController pushViewController:registrationViewController animated:YES];

    } else {
        /* Courier registration only on server side */
        [UIAlertView showAlertWithTitle:NSLocalizedString(@"ctrl.courier.registration.msg.title", nil)
                                message:NSLocalizedString(@"ctrl.courier.registration.msg", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"generic.ok", nil)
                      otherButtonTitles:NSLocalizedString(@"generic.call", nil), nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[AppDelegate instance] showLoadingView];
        [[Server instance] supportPhoneSuccess:^(NSString *phoneNumber) {
            [[AppDelegate instance] hideLoadingView];
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
        } failure:^(NSError *error, NSInteger code) {
            [[AppDelegate instance] hideLoadingView];
        }];
    }
}

- (IBAction) loginAction:(UIButton *)sender
{
    if ([self validateFields])
    {
        [[AppDelegate instance] showLoadingView];
        
        NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
        
        UserModel *userModel = [[UserModel alloc] init];
        userModel.phone = phone;
        userModel.password = self.passField.text;
        userModel.deviceId = deviceId;
        userModel.isFB = NO;        
        
        [[Server instance] loginWithModel:userModel
                                  success:^(UserModel *userModel)
         {
             [[AppDelegate instance] hideLoadingView];
             [[Settings instance] setPassword:self.passField.text];
             [[Settings instance] setCurrentUser:userModel];
             [super getUserData];
             
             if (IS_COURIER_APP)
                 [self dismissViewControllerAnimated:YES completion:nil];
             else {
                 [self dismissViewControllerAnimated:YES completion:^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:showCenterView object:nil];
                 }];
             }
             
         } failure:^(NSError *error, NSInteger code) {
             
             [[AppDelegate instance] hideLoadingView];
             switch (code) {
                 case 409:
                     [self setTextCololInField:self.phoneField colol:[UIColor redColor]];
                     [self setTextCololInField:self.passField colol:[UIColor redColor]];
                     [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredData", nil) target:self];
                     break;
                     
                 case 404:
                     [Utilities showErrorMessage:NSLocalizedString(@"msg.login.404", nil) target:self];
                     break;
                     
                 default:
                     [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                     break;
             }
         }];
    }
}

- (IBAction) conectWithFacebook:(UIButton *)sender
{
    [[SocialManager instance] autoriseInFBAndGetUseDataWithSuccess:^(UserModel *userModel) {
        
        [[AppDelegate instance] showLoadingView];
        
        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
        
        UserModel *_userModel = [[UserModel alloc] init];
        
        _userModel.deviceId = deviceId;
        
        _userModel.socialId  = userModel.socialId;
        _userModel.deviceId  = userModel.deviceId;
        _userModel.password  = userModel.socialId;
        _userModel.name      = userModel.name;
        _userModel.avatarURL = userModel.avatarURL;
        _userModel.isFB      = YES;
        
        NSString *md5 = userModel.socialId.md5;
        _userModel.socialHash = md5.sha1;
        
        [[Server instance] loginWithModel:_userModel
                                  success:^(UserModel *userModel) {
                                      [[AppDelegate instance] hideLoadingView];
                                      [[Settings instance] setCurrentUser:userModel];
                                      
                                      [super getUserData];
                                      
                                      [self dismissViewControllerAnimated:YES completion:^{
                                          [[NSNotificationCenter defaultCenter] postNotificationName:showCenterView object:nil];
                                      }];
                                  } failure:^(NSError *error, NSInteger code) {
                                      [[AppDelegate instance] hideLoadingView];
                                      switch (code) {
                                          case 404:
                                              [self showCompleteRegistrationView:_userModel];
                                              break;
                                              
                                          default:
                                              [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                                              break;
                                      }
                                  }];
        
    } failure:^(NSError *error, NSString *status) {}];
}

- (void) showCompleteRegistrationView:(UserModel *) userModel
{
    CompleteRegistrationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteRegistrationViewController"];
    ctr.userModel = userModel;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (BOOL) validateFields
{
    if (self.phoneField.text.length == 0) {
        [self setTextCololInField:self.phoneField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.phoneNumber", nil) target:self];
        return NO;
    }
    
    else if (self.phoneField.text.length < 15) {
        [self setTextCololInField:self.phoneField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPhoneNumberCharacters", nil) target:self];
        return NO;
    }
    
    else if (self.passField.text.length <= 0) {
        [self setTextCololInField:self.passField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.password", nil) target:self];
        return NO;
    }
    
    return YES;
}

- (void) lowerKeyboard
{
    [self.phoneField resignFirstResponder];
    [self.passField resignFirstResponder];
}

- (void) setTextCololInField:(TextField *) textfild colol:(UIColor *) color
{
    [UIView animateWithDuration:duration
                     animations:^{
                         textfild.textColor = color;
                         [textfild setValue:color forKeyPath:@"_placeholderLabel.textColor"];
                     }];
}

#pragma mark - UITextFieldDelegate
#pragma mark -

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

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneField) {
        if (textField.isEmpty)
            textField.text = [NSString stringWithFormat:@"%@ ",kPhoneCodePrefix];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
