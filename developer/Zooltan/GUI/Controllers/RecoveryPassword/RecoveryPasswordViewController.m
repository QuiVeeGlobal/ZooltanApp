//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "RecoveryPasswordViewController.h"
#import "ValidationViewController.h"

#define duration 0.5
#define durationAnomation 0.3f
#define keyboardHeight 260

@interface RecoveryPasswordViewController () <TextFieldButtonDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitle;

@property (weak, nonatomic) IBOutlet TextField *phoneField;

@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@end

@implementation RecoveryPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)configureView
{
    [super configureView];
    
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [self setBottomLine:self.phoneField];
    
    [self addCornerRadius:self.sendBtn];
    
    self.mainTitle.text = NSLocalizedString(@"ctrl.recoveryPassword.main.title", nil);
    self.descriptionTitle.text = NSLocalizedString(@"ctrl.recoveryPassword.main.description", nil);
    self.phoneField.placeholder = NSLocalizedString(@"ctrl.recoveryPassword.placeholder.phone", nil);
    self.sendBtn.titleLabel.text = NSLocalizedString(@"ctrl.recoveryPassword.placeholder.phone", nil);
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

- (void) setTextCololInField:(TextField *) textfild colol:(UIColor *) color
{
    [UIView animateWithDuration:duration
                     animations:^{
                         textfild.textColor = color;
                         [textfild setValue:color forKeyPath:@"_placeholderLabel.textColor"];
                     }];
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) sendPhoneAction:(UIButton *)sender
{
     self.sendBtn.enabled = NO;
    if ([self validateFields])
    {
        NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
       
        [[AppDelegate instance] showLoadingView];
        [[Server instance] checkForRecoveryPhoneNumber:phone success:^{
            [[CheckMobi instance] verifyPhoneNumber:phone
                                    completionBlock:^(NSError *error) {
                                        [[AppDelegate instance] hideLoadingView];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.sendBtn.enabled = YES;
                                        });
                                        if (!error) {
                                            [self showValidationScreen];
                                        }
                                    }];
        } failure:^(NSError *error, NSInteger code) {
            [[AppDelegate instance] hideLoadingView];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendBtn.enabled = YES;
            });
            
            switch (code) {
                case 404:
                    [Utilities showErrorMessage:NSLocalizedString(@"msg.error.userNotFound", nil) target:self];
                    break;
                case 403:
                    [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                    break;
                default:
                    [Utilities showErrorMessage:NSLocalizedString(@"msg.error.general", nil) target:self];
                    break;
            }
        }];
    } else {
        self.sendBtn.enabled = YES;
    }
}

- (void) showValidationScreen
{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UserModel *userModel = [[Settings instance] currentUser];
    userModel.phone = phone;
    
    ValidationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationViewController"];
    ctr.validationType = RecoveryValidation;
    ctr.userModel = userModel;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sendBtn.enabled = YES;
    });

}

- (void) lowerKeyboard
{
    [self.phoneField resignFirstResponder];
}

- (BOOL) validateFields
{
    if (self.phoneField.text.length < 15) {
        [self setTextCololInField:self.phoneField colol:[UIColor redColor]];
        [Utilities showErrorMessage:NSLocalizedString(@"msg.error.enteredPhoneNumberCharacters", nil) target:self];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [[Phone instance] configurePhoneNumberFromTextField:textField
                                         withCharactersInRange:range
                                                        string:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneField) {
        if (textField.isEmpty) {
            textField.text = [NSString stringWithFormat:@"%@ ",kPhoneCodePrefix];
        }
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
