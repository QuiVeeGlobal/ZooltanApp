


#import "DeliveryCell.h"


@implementation DeliveryCell

+ (CGFloat)cellHeight
{
    return 340;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.backgroundColor = [Colors lightBlueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction) touchCell:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deliveryCellDidPressButton:atIndexPath:)])
        [self.delegate deliveryCellDidPressButton:nil atIndexPath:self.indexPath];
}

@end
