//
//  ValidationViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 07.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "ValidationViewController.h"
#import "NewPasswordViewController.h"

#define layerBorderWidth 1.5
#define layerCornerRadius 2.5
#define bottomLineWidth 1
#define duration 1
#define durationAnomation 0.3f
#define keyboardHeight 260

@interface ValidationViewController ()

@property (strong, nonatomic) IBOutlet TextField *pinCodeField;

@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIButton *canceldBtn;
@property (strong, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionTitleLabel;

@end

@implementation ValidationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.sendBtn.bottom+110);
}

- (void)configureView
{
    [super configureView];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancelAction)];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(doneAction)];
    keyboardToolbar.items = @[cancelBarButton, flexBarButton, doneBarButton];
    
    keyboardToolbar.translucent = YES;
    keyboardToolbar.barTintColor = [UIColor blackColor];
    [keyboardToolbar setTintColor:[UIColor whiteColor]];
    
    self.pinCodeField.inputAccessoryView = keyboardToolbar;
    self.pinCodeField.keyboardType = UIKeyboardTypePhonePad;
    self.pinCodeField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [self setBottomLine:self.pinCodeField];
    
    [self addCornerRadius:self.sendBtn];
    self.sendBtn.backgroundColor = [Colors yellowColor];
    
    [self addCornerRadius:self.canceldBtn];
    
    self.mainTitleLabel.text = NSLocalizedString(@"ctrl.validation.main.title", nil);
    self.descriptionTitleLabel.text = NSLocalizedString(@"ctrl.validation.description.title", nil);
    self.pinCodeField.placeholder = NSLocalizedString(@"ctrl.validation.placeholder.code", nil);
    self.sendBtn.titleLabel.text = NSLocalizedString(@"ctrl.validation.button.send", nil);
    self.canceldBtn.titleLabel.text = NSLocalizedString(@"ctrl.validation.button.cancel", nil);
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
    btn.layer.borderWidth = 2.0f;
    btn.layer.borderColor = [Colors yellowColor].CGColor;
}

- (void) setBottomLine:(TextField *) textField
{
    textField.tintColor = [Colors yellowColor];
    
    textField.textColor = [Colors whiteColor];
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.borderColor = [Colors yellowColor].CGColor;
    bottomLine.frame = CGRectMake(0, textField.height-layerBorderWidth, textField.width, textField.height);
    bottomLine.borderWidth = layerBorderWidth;
    [textField.layer addSublayer:bottomLine];
    textField.clipsToBounds = YES;
    textField.layer.masksToBounds = YES;
    textField.bottomLine = bottomLine;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction)sendAction:(id)sender
{
    if ([self validateFields]) {

        [[CheckMobi instance] validatePinCode:self.pinCodeField.text
                              completionBlock:^(NSError *error) {
                                  
                                  if (!error) {
                                      if (self.validationType == RegistrationValidation)
                                          [self singUpWithModel];
                                      
                                      if (self.validationType == RecoveryValidation)
                                          [self showNewPassScreen];
                                      
                                  }
                              }];
    }
}

- (void)singUpWithModel
{
    [[AppDelegate instance] showLoadingView];
    
    [[Server instance] signUpWithModel:self.userModel
                               success:^(UserModel *userModel) {
                                   
                                   if (self.userModel.isFB) {
                                       [[Settings instance] setPassword:self.userModel.socialId];
                                       [self setProfileAvatar:self.userModel.avatarURL];
                                   }
                                   else
                                       [[Settings instance] setPassword:self.userModel.password];
                                   
                                   [[AppDelegate instance] hideLoadingView];
                                   [[Settings instance] setCurrentUser:userModel];
                                   [super getUserData];
                                   
                                   [self dismissViewControllerAnimated:YES completion:^{
                                       [[NSNotificationCenter defaultCenter] postNotificationName:showCenterView object:nil];
                                   }];
                               } failure:^(NSString *error, NSInteger code) {
                                   [[AppDelegate instance] hideLoadingView];
                                   if (code == 409)
                                       [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredData", nil) target:self];
                                   else
                                       [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                               }];
}

- (void) setProfileAvatar:(NSString *) path
{
    [[Server instance] uploadImageFromPath:path
                                   success:^(UserModel *userModel) {
                                       [[Settings instance] setCurrentUser:userModel];
                                   } failure:^(NSError *error, NSInteger code) {
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

- (IBAction)cancelAction:(id)sender
{
    [self closeValidation];
}

- (void) closeValidation
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) showNewPassScreen
{
    NewPasswordViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"NewPasswordViewController"];
    ctr.userModel = self.userModel;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
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
    [self.pinCodeField resignFirstResponder];
}

- (BOOL) validateFields
{
    if (self.pinCodeField.text.length == 0) {
        [self setTextCololInField:self.pinCodeField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.pinCode", nil) target:self];
        return NO;
    }
    
    if (self.pinCodeField.text.length < 4 || self.pinCodeField.text.length > 4) {
        [self setTextCololInField:self.pinCodeField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPinCodeCharacters", nil) target:self];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self performBlock:^{
        self.scrollView.contentSize = CGSizeMake(self.view.width, self.sendBtn.bottom+keyboardHeight);
    } afterDelay:0];
    
    if (textField == self.pinCodeField)
        [self scrollRectToVisible:CGRectMake(0, self.pinCodeField.y-keyboardHeight/2, self.scrollView.width, self.scrollView.height)];
}

- (void) scrollRectToVisible:(CGRect) rect
{
    [self performBlock:^{
        [self.scrollView scrollRectToVisible:rect animated:YES];
    } afterDelay:durationAnomation];
}

#pragma mark - UIKeyboardWillHideNotification
#pragma mark -

- (void)keyboardWillHide:(NSNotification *)notifications
{
    [UIView animateWithDuration:0.35f
                     animations:^{
                         self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height);
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
