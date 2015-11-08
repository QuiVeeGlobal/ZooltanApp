//
//  BaseNavigationCtrl.m
//  Travel
//
//  Created by Eugene Vegner on 17.03.15.
//  Copyright (c) 2015 Eugene Vegner. All rights reserved.
//

#import "BaseNavigationCtrl.h"

@interface BaseNavigationCtrl ()

@end

@implementation BaseNavigationCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateShadowView:)
                                                 name:@"MMDrawerSideRightPercentVisible"
                                               object:nil];
    
    if (!self.shadowView) {
        self.shadowView = [[UIView alloc] initWithFrame:[AppDelegate instance].window.bounds];
        self.shadowView.userInteractionEnabled = NO;
        self.shadowView.backgroundColor = [Colors yellowColor];
        self.shadowView.alpha = 0;
        [self.view addSubview:self.shadowView];
    }
}

- (void)updateShadowView:(NSNotification *)notification {
    
    NSNumber *prc = notification.object;
    STLogDebug(@"percentVisible: %@",prc);
    
    float percent = prc.floatValue;
    if (percent > 0.75) {
        percent = 0.75;
    }
    
    self.shadowView.alpha = percent;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
