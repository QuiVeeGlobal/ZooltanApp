


#import <UIKit/UIKit.h>

@protocol InformationCellDelegate;

@interface InformationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) id <InformationCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)cellHeight;

@end

@protocol InformationCellDelegate <NSObject>

@optional

- (void)informationCellDidPressButton:(UIButton *)button
                          atIndexPath:(NSIndexPath *)indexPath;

@end