


#import "AdressCell.h"


@implementation AdressCell

+ (CGFloat)cellHeight
{
    return 60;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textColor = [Colors darkGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction) touchCell:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(adressCellDidPressButton:atIndexPath:)])
        [self.delegate adressCellDidPressButton:nil atIndexPath:self.indexPath];
}

@end
