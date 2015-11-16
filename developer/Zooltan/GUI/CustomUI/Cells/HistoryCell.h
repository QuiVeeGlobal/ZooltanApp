


#import <UIKit/UIKit.h>

@protocol HistoryCellDelegate;

@interface HistoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *addressTitle;
@property (nonatomic, weak) IBOutlet UILabel *statusTitle;
@property (nonatomic, weak) IBOutlet UILabel *noteTitle;
//@property (nonatomic, weak) IBOutlet UILabel *pickedUpTitle;
//@property (nonatomic, weak) IBOutlet UILabel *deliveredTitle;

@property (nonatomic, weak) IBOutlet UILabel *typeDeliveryLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *noteLabel;
//@property (nonatomic, weak) IBOutlet UILabel *pickedUpLabel;
//@property (nonatomic, weak) IBOutlet UILabel *deliveredLabel;

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *packageImage;

@property (nonatomic, assign) id <HistoryCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol HistoryCellDelegate <NSObject>

@optional

- (void)historyCellDidPressButton:(UIButton *)button
                      atIndexPath:(NSIndexPath *)indexPath;

@end