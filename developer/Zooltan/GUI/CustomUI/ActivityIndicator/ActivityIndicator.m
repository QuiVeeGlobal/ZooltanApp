

#import "ActivityIndicator.h"
#import "AppDelegate.h"

@implementation ActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.frame = [AppDelegate instance].window.frame;
            self.backgroundColor = [UIColor clearColor];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            //   spinner.color = [UIColor redColor];
            spinner.frame = CGRectMake(140, 220, 40, 40);
//            spinner.frame = CGRectZero ;
            spinner.backgroundColor = [UIColor clearColor];
            [self addSubview:spinner];
            spinner.center = self.center;
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
            // self.alpha = .3;
        }
    }
    return self;
}

-(void)dealloc{
    spinner = nil;
}

-(void)startSpinner{
    [spinner startAnimating];
}

-(void)stopSpinner{
    [spinner stopAnimating];
}


@end
