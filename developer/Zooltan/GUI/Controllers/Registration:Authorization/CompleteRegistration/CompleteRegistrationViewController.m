//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "CompleteRegistrationViewController.h"
#import "ValidationViewController.h"

#define layerBorderWidth 1.5
#define layerCornerRadius 2.5
#define bottomLineWidth 1
#define duration 1

@interface CompleteRegistrationViewController () <TextFieldButtonDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTitle;

@property (weak, nonatomic) IBOutlet TextField *phoneField;

@property (nonatomic, weak) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIButton *skipBtn;

@end

@implementation CompleteRegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.skipBtn.hidden = YES;
}

- (void)configureView
{
    [super configureView];
    
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [self setBottomLine:self.phoneField];
    
    [self addCornerRadius:self.sendBtn];
    
    self.mainTitle.text = NSLocalizedString(@"ctrl.completeRegistration.main.title", nil);
    self.descriptionTitle.text = NSLocalizedString(@"ctrl.completeRegistration.main.description", nil);
    self.phoneField.placeholder = NSLocalizedString(@"ctrl.completeRegistration.placeholder.phone", nil);
    self.sendBtn.titleLabel.text = NSLocalizedString(@"ctrl.completeRegistration.button.send", nil);
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
    btn.backgroundColor = [Colors yellowColor];
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

- (IBAction) sendPhoneAction:(UIButton *)sender
{
    self.sendBtn.enabled = NO;
    
    if ([self validateFields])
    {
        NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        self.userModel.phone = phone;
        self.userModel.isFB = YES;
        
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
    ValidationViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationViewController"];
    ctr.validationType = RegistrationValidation;
    ctr.userModel = self.userModel;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (void) lowerKeyboard
{
    [self.phoneField resignFirstResponder];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [[Phone instance] configurePhoneNumberFromTextField:textField
                                         withCharactersInRange:range
                                                        string:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
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
