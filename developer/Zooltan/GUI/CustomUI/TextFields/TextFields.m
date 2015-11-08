//
//  TextFields.m
//  Experts
//
//  Created by Eugene Vegner on 03.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import "TextFields.h"

@implementation TextField

#define kEXTextFieldHeight 35
#define kIconSize 20
#define kIconInset 10

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.height = kEXTextFieldHeight;
    //self.font = [UIFont systemFontOfSize:self.font.pointSize];
    self.borderStyle = UITextBorderStyleNone;
    //self.edgeInsets = UIEdgeInsetsMake(10, 0, 0, 10);
    //self.layer.borderWidth = 1;
    //self.layer.borderColor = [[Colors whiteColor] CGColor];
    //self.layer.cornerRadius = 4;
    self.textColor = [Colors whiteColor];
    self.backgroundColor = [UIColor clearColor];
    //self.contentMode = UIViewContentModeLeft;
//    self.background = [[UIImage imageNamed:@"input-field-edge"]
//                       stretchableImageWithLeftCapWidth:8
//                       topCapHeight:0];
    
    //self.height = kEXTextFieldHeight;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

#pragma mark - Setters

- (void)setLeftIcon:(UIImage *)leftIcon {
    _leftIcon = leftIcon;
    if (_leftIcon)
    {
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [self setIcon:_leftIcon withType:TextFieldButtonTypeLeft];
        self.leftView.x = 10;
    }
}

- (void)setRightIcon:(UIImage *)rightIcon {
    _rightIcon = rightIcon;
    if (_rightIcon) {
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = [self setIcon:_rightIcon withType:TextFieldButtonTypeRight];
    }
}

#pragma mark - SET Icon

- (UIImageView *)setIcon:(UIImage *)icon withType:(TextFieldButtonType)type
{
    CGFloat left = (type == TextFieldButtonTypeLeft) ? kIconInset : self.width - kIconInset+kIconSize;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, 0, kIconSize, kIconSize)];
    [imageView setImage:icon];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    return imageView;
}

- (UIButton*)setButtonIcon:(UIImage *)icon withType:(TextFieldButtonType)type
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    button.contentMode = UIViewContentModeCenter;
    [button setImage:icon forState:UIControlStateNormal];
    [button setTag:(NSInteger)type];
    [button addTarget:self action:@selector(actionButtonPress:) forControlEvents:UIControlEventTouchDown];
    return button;
}

#pragma mark - Delegate

- (void)actionButtonPress:(UIButton*)button {
    if ([self.buttonDelegate respondsToSelector:@selector(textField:didPressButton:)]) {
        [self.buttonDelegate textField:self didPressButton:button];
    }
}

#pragma mark - Validation

- (BOOL)validateEmail
{
    /*
     NSString *emailRegEx =
     @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
     @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
     @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
     @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
     @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
     @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
     @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
     */
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.text];
}


- (BOOL)validatePassword
{
    if (self.text == nil) {
        return NO;
    }
    
//    if (self.text.length >= 6 && self.text.length <= 26) {
//        return YES;
//    }
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}


@end
