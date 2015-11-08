//
//  ContactViewCell.m
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "ContactViewCell.h"

#define kLineOffset 15

@implementation ContactViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CALayer *line = [CALayer new];
    line.backgroundColor = [UIColor grayColor].CGColor;
    line.borderWidth = 1;
    line.frame = CGRectMake(kLineOffset,
                            self.height-line.borderWidth,
                            self.width - (kLineOffset*2),
                            line.borderWidth);
    [self.layer addSublayer:line];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
