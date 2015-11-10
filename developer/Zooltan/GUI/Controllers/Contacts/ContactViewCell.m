//
//  ContactViewCell.m
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "ContactViewCell.h"

//#define kLineOffset 15

@implementation ContactViewCell

+ (CGFloat)cellHeight
{
    return 100;
}

- (void)awakeFromNib
{
    [self addCornerRadius:self.photo radius:self.photo.height/2];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CALayer *line = [CALayer new];
//    line.backgroundColor = [UIColor lightGrayColor].CGColor;
//    line.borderWidth = 1;
//    line.frame = CGRectMake(kLineOffset,
//                            self.height-line.borderWidth,
//                            self.width - (kLineOffset*2),
//                            line.borderWidth);
//    [self.layer addSublayer:line];
}

- (void) addCornerRadius:(UIImageView *)view radius:(float) radius
{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)touchCell:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactViewCellDelegateDidPressButton:atIndexPath:)])
        [self.delegate contactViewCellDelegateDidPressButton:nil atIndexPath:self.indexPath];
}

@end
