//
//  NewPasswordViewController.m
//  Zooltan
//
//  Created by Alex Sorokolita on 19.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "RecoveryPasswordViewController.h"

#define durationAnomation 0.3f
#define keyboardHeight 260

@interface NewPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitle;

@property (weak, nonatomic) IBOutlet TextField *nPassField;
@property (weak, nonatomic) IBOutlet TextField *repeatPassField;

@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@end

@implementation NewPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)configureView
{
    [super configureView];
    
    self.nPassField.secureTextEntry = YES;
    self.repeatPassField.secureTextEntry = YES;
    
    self.nPassField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.repeatPassField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [self setBottomLine:self.nPassField];
    [self setBottomLine:self.repeatPassField];
    
    [self addCornerRadius:self.sendBtn];
       
    self.mainTitle.text = NSLocalizedString(@"ctrl.newPassword.main.title", nil);
    self.descriptionTitle.text = NSLocalizedString(@"ctrl.newPassword.description.title", nil);
    self.sendBtn.titleLabel.text = NSLocalizedString(@"ctrl.newPassword.button.send", nil);
    self.nPassField.placeholder = NSLocalizedString(@"ctrl.newPassword.placeholder.newPassword", nil);
    self.repeatPassField.placeholder = NSLocalizedString(@"ctrl.newPassword.placeholder.repeatPassword", nil);
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = 2.5;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [Colors yellowColor];
}

- (void) setBottomLine:(TextField *) textField
{
    textField.tintColor = [Colors yellowColor];
    
    textField.textColor = [Colors whiteColor];
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    CALayer *bottomLine = [CALayer layer];
    CGFloat borderWidth = 1;
    bottomLine.borderColor = [Colors yellowColor].CGColor;
    bottomLine.frame = CGRectMake(0, textField.height-borderWidth, textField.width, textField.height);
    bottomLine.borderWidth = borderWidth;
    [textField.layer addSublayer:bottomLine];
    textField.clipsToBounds = YES;
    textField.layer.masksToBounds = YES;
    textField.bottomLine = bottomLine;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) sendAction:(UIButton *)sender
{
    NSString *phone = [NSString stringWithFormat:@"%@", self.userModel.phone];
    
    if ([self validateFields]) {
        [[Server instance] updatePassword:self.nPassField.text
                           forPhoneNumber:phone
                                  success:^{
                                      [self loginWithModel];
                                  } failure:^(NSError *error, NSInteger code) {
                                  }];
    }
}

- (void) loginWithModel
{
    [[AppDelegate instance] showLoadingView];
    
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    
    UserModel *userModel = self.userModel;
    userModel.phone = self.userModel.phone;
    userModel.password = self.nPassField.text;
    userModel.deviceId = deviceId;
    
    [[Server instance] loginWithModel:userModel
                              success:^(UserModel *userModel) {
                                  [[AppDelegate instance] hideLoadingView];
                                  [self dismissViewControllerAnimated:YES completion:^{
                                      [[NSNotificationCenter defaultCenter] postNotificationName:showCenterView object:nil];
                                  }];
                              } failure:^(NSError *error, NSInteger code) {
                                  [[AppDelegate instance] hideLoadingView];
                              }];
}

- (IBAction)backAction:(id)sender {

    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[RecoveryPasswordViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) lowerKeyboard
{
    [self.nPassField resignFirstResponder];
    [self.repeatPassField resignFirstResponder];
}

- (BOOL) validateFields
{
    if (self.nPassField.text.length == 0 && self.repeatPassField.text.length == 0) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.newPassword", nil) target:self];
    }
    else if (self.nPassField.text.length > 0 && self.repeatPassField.text.length == 0) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.repeatPassword", nil) target:self];
    }
    else if (self.repeatPassField.text.length > 0 && self.nPassField.text.length == 0) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.newPassword", nil) target:self];
    }
    else if (![self.nPassField.text isEqualToString:self.repeatPassField.text]) {
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredDifferentPasswords" , nil) target:self];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
