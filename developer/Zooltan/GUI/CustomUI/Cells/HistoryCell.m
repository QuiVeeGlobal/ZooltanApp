


#import "HistoryCell.h"


@implementation HistoryCell

+ (CGFloat)cellHeight
{
    return 103;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.addressTitle.text = NSLocalizedString(@"ctrl.history.cell.address", nil);
    self.statusTitle.text = NSLocalizedString(@"ctrl.history.cell.status.title", nil);
    self.noteTitle.text = NSLocalizedString(@"ctrl.history.cell.note.title", nil);
//    self.pickedUpTitle.text = NSLocalizedString(@"ctrl.history.cell.pickedUp", nil);
//    self.deliveredTitle.text = NSLocalizedString(@"ctrl.history.cell.delivered", nil);

//    self.bgView.backgroundColor = [Colors lightBlueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) touchCell:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyCellDidPressButton:atIndexPath:)])
        [self.delegate historyCellDidPressButton:nil atIndexPath:self.indexPath];
}

@end
