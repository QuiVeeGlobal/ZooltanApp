//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "RegistrationViewController.h"
#import "CompleteRegistrationViewController.h"
#import "SocialManager.h"
#import "UserAgreementViewController.h"
#import "ValidationViewController.h"

#define layerBorderWidth 1.5
#define layerCornerRadius 2.5
#define bottomLineWidth 1
#define duration 1
#define durationAnomation 0.3f

#define keyboardHeight 260

#define nameFieldMaxLenght 256

@interface RegistrationViewController () <TextFieldButtonDelegate, UITextFieldDelegate>
{
}

@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
@property (nonatomic, weak) IBOutlet UILabel *acceptLabel;

@property (weak, nonatomic) IBOutlet TextField *nameField;
@property (weak, nonatomic) IBOutlet TextField *phoneField;
@property (weak, nonatomic) IBOutlet TextField *passField;

@property (nonatomic, weak) IBOutlet UIButton *signUpBtn;
@property (nonatomic, weak) IBOutlet UIButton *agreeBtn;
@property (nonatomic, weak) IBOutlet UIButton *fbBtn;

@property (nonatomic, weak) IBOutlet UIButton *callBtn; // Courier ver.
@property (nonatomic, weak) IBOutlet UIButton *officeMapBtn; // Courrier ver.

@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)configureView
{
    [super configureView];

    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.passField.secureTextEntry = YES;
    self.passField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.nameField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [self setBottomLine:self.nameField];
    [self setBottomLine:self.phoneField];
    [self setBottomLine:self.passField];
    
    [self addCornerRadius:self.signUpBtn];
    [self addCornerRadius:self.fbBtn];
    
    self.signUpBtn.backgroundColor = [Colors yellowColor];
    self.agreeBtn.titleLabel.textColor = [Colors yellowColor];
    
    if (![_deteckScreen() isEqualToString:@"iPhone3,1"] &&
        ![_deteckScreen() isEqualToString:@"iPhone3,2"] &&
        ![_deteckScreen() isEqualToString:@"iPhone3,3"])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"ctrl.regestration.button.licence", nil)
                                                                                 attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}]];
        
        self.agreeBtn.titleLabel.attributedText = attributedString;
    }
    
    self.mainTitle.text = NSLocalizedString(@"ctrl.regestration.main.title", nil);
    
    self.acceptLabel.text = (IS_COURIER_APP)
    ? NSLocalizedString(@"ctrl.regestration.accept.title.courier", nil)
    : NSLocalizedString(@"ctrl.regestration.accept.title", nil);

    self.signUpBtn.titleLabel.text = NSLocalizedString(@"ctrl.regestration.button.sign_up", nil);
    self.fbBtn.titleLabel.text = NSLocalizedString(@"ctrl.regestration.button.fb", nil);
    self.nameField.placeholder = NSLocalizedString(@"ctrl.regestration.placeholder.name", nil);
    self.phoneField.placeholder = NSLocalizedString(@"ctrl.regestration.placeholder.phone", nil);
    self.passField.placeholder = NSLocalizedString(@"ctrl.regestration.placeholder.password", nil);
    self.callBtn.titleLabel.text = NSLocalizedString(@"ctrl.regestration.button.call", nil);
    self.officeMapBtn.titleLabel.text = NSLocalizedString(@"ctrl.regestration.button.office_map", nil);
    
    self.officeMapBtn.layer.borderColor = [Colors yellowColor].CGColor;
    self.officeMapBtn.layer.borderWidth = layerBorderWidth;
    self.officeMapBtn.titleLabel.textColor = [Colors yellowColor];
    
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

NSString* _deteckScreen()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) registrationAction:(UIButton *)sender
{
    self.signUpBtn.enabled = NO;
    
    if ([self validateFields])
    {
        NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

        [[CheckMobi instance] verifyPhoneNumber:phone
                                completionBlock:^(NSError *error) {
                                    
                                    if (!error) {
                                        [self showValidationScreen];
                                    }
                                }];
    }
}

- (void) showValidationScreen
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UserModel *userModel = [[UserModel alloc] init];
    userModel.name = self.nameField.text;
    userModel.phone = phone;
    userModel.password = self.passField.text;
    userModel.isFB = NO;
    
    ValidationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationViewController"];
    ctr.userModel = userModel;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (IBAction) enterWithFacebook:(UIButton *)sender
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

- (IBAction)agreeAction:(id)sender
{
    UserAgreementViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"UserAgreementViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (IBAction)callAction:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",[Constants officeCallNumber]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    
    } else {
        [UIAlertView showAlertWithTitle:NSLocalizedString(@"generic.call", nil)
                                message:NSLocalizedString(@"ctrl.regestration.call.incopatible", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"generic.ok", nil)
                      otherButtonTitles:nil, nil];
    }
}

- (void) showCompleteRegistrationView:(UserModel *) userModel
{
    CompleteRegistrationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteRegistrationViewController"];
    ctr.userModel = userModel;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void) doneAction
{
    [self lowerKeyboard];
}

- (void) cancelAction
{
    [self lowerKeyboard];
}

- (void) lowerKeyboard
{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.passField resignFirstResponder];
}

- (BOOL) validateFields
{
    if (self.nameField.text.length == 0) {
        [self setTextCololInField:self.nameField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.name", nil) target:self];
        return NO;
    }
    else if (self.nameField.text.length < kMinCharactersLength) {
        [self setTextCololInField:self.nameField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredNameCharacters", nil) target:self];
        return NO;
    }
    else if (self.phoneField.text.length == 0) {
        [self setTextCololInField:self.phoneField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.phoneNumber", nil) target:self];
        return NO;
    }
    
    else if (self.phoneField.text.length < 15) {
        [self setTextCololInField:self.phoneField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPhoneNumberCharacters", nil) target:self];
        return NO;
    }
    else if (self.passField.text.length == 0)
    {
        [self setTextCololInField:self.passField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.password", nil) target:self];
        return NO;
    }
    return YES;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextCololInField:self.nameField colol:[UIColor whiteColor]];
    [self setTextCololInField:self.phoneField colol:[UIColor whiteColor]];
    [self setTextCololInField:self.passField colol:[UIColor whiteColor]];
    
    if (textField == self.phoneField) {
        if (textField.isEmpty)
            textField.text = [NSString stringWithFormat:@"%@ ",kPhoneCodePrefix];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.phoneField == textField)
    {
        return [[Phone instance] configurePhoneNumberFromTextField:textField
                                             withCharactersInRange:range
                                                            string:string];
    }
    
    if ([self.nameField.text length] > nameFieldMaxLenght) {
        self.nameField.text = [self.nameField.text substringToIndex:nameFieldMaxLenght - 1];
        return NO;
    }
    
    return true;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
