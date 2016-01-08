//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "HistoryViewController.h"
#import "TrakingViewController.h"
#import "CreateViewController.h"
#import "HistoryCell.h"
#import "AFNetworking.h"
#import "PackagePhotoViewController.h"

#define layerCornerRadius 2.5
#define REQUEST self.manager

@interface HistoryViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, HistoryCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *sendNew;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSMutableArray *ordersArray;
@property (strong, nonatomic) NSDictionary *currentOrderDic;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *requerstUrl;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [Colors yellowColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)refreshTable
{
    [self getOrders];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getOrders];
}

- (void)getOrders
{
    if (!self.refreshControl.isRefreshing)
        [[AppDelegate instance] showLoadingView];
    
    if (!self.requerstUrl)
        self.requerstUrl = [NSString stringWithFormat:@"/client/orders/active/1/100"];
    
    [REQUEST.requestSerializer setValue:[[Settings instance] token] forHTTPHeaderField:@"token"];
    
    [REQUEST GET:self.requerstUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         STLogSuccess(@"/client/orders RESPONSE: %@",responseObject);
         
         if (operation.response.statusCode == 200 || operation.response.statusCode == 201)
         {
             self.ordersArray = responseObject[@"orders"];
             [self.tableView reloadData];
             [self.refreshControl endRefreshing];
             [[AppDelegate instance] hideLoadingView];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         STLogSuccess(@"/client/orders failure: %@",operation.responseString);
         [self.refreshControl endRefreshing];
         [[AppDelegate instance] hideLoadingView];
     }];
}

- (void)configureView
{
    [super configureView];
    
    NSDictionary *titleParam = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [Fonts setOpenSansWithFontSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleParam];
    
    self.segmentedControl.backgroundColor = [Colors clearColor];
    self.segmentedControl.tintColor = [Colors yellowColor];
    
    self.navItem.title = NSLocalizedString(@"ctrl.history.navigation.title", nil);
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.history.segmented.title1", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.history.segmented.title2", nil) forSegmentAtIndex:1];
    
    [self addCornerRadius:self.sendNew];
}

- (void) addBottomLineInLabel:(UILabel *) label
{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, label.height-1, label.width, label.height);//textFild.height - borderWidth
    border.borderWidth = borderWidth;
    [label.layer addSublayer:border];
    label.clipsToBounds = YES;
    label.layer.masksToBounds = YES;
}

- (void) addCornerRadius:(UIButton *) btn
{
    btn.layer.cornerRadius = layerCornerRadius;
    btn.clipsToBounds = YES;
}

#pragma mark - IBAction
#pragma mark -

- (IBAction) segmentedAction:(UISegmentedControl *) sender
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: self.requerstUrl = [NSString stringWithFormat:@"/client/orders/active/1/100"]; break;
        case 1: self.requerstUrl = [NSString stringWithFormat:@"/client/orders/history/1/100"]; break;
        default: break;
    }
    [self getOrders];
}

- (IBAction) sendNewAction:(UISegmentedControl *) sender
{
    PackagePhotoViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"PackagePhotoViewController"];
    [self.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HistoryCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.ordersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryCell.className
                                                        forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.backgroundColor = [UIColor clearColor];
    
    __block OrderModel *order = [[OrderModel alloc] initWithDictionary:self.ordersArray[indexPath.row]];
    
    cell.typeDeliveryLabel.text = [order.size stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    cell.costLabel.text = [NSString stringWithFormat:@"AED %@", order.cost];
    cell.addressLabel.text = order.toAddress;
    cell.statusLabel.text = order.orderStatusTitle;
    cell.noteLabel.text = order.comment;
    
    if ([order.size isEqualToString:@"LETTER"])
        cell.packageImage.image = [UIImage imageNamed:@"LetterBoxIcon"];
    
    if ([order.size isEqualToString:@"SMALL_BOX"])
        cell.packageImage.image = [UIImage imageNamed:@"SmallBoxIcon"];
    
    if ([order.size isEqualToString:@"BIG_BOX"])
        cell.packageImage.image = [UIImage imageNamed:@"BigBoxIcon"];
    
    if (order.orderStatus == OrderStatusNew)
        cell.bgView.backgroundColor = [Colors lightBlueColor];
    else if (order.orderStatus == OrderStatusProgress)
        cell.bgView.backgroundColor = [Colors lightYellowColor];
    else if (order.orderStatus == OrderStatusClose)
        cell.bgView.backgroundColor = [Colors lightRedColor];
    else
        cell.bgView.backgroundColor = [Colors lightGreenColor];
    
    return cell;
}

- (void)historyCellDidPressButton:(UIButton *)button
                      atIndexPath:(NSIndexPath *)indexPath
{
    [[AppDelegate instance] showLoadingView];
    
    __block OrderModel *order = [[OrderModel alloc] initWithDictionary:self.ordersArray[indexPath.row]];
    
    [[Server instance] viewOrder:order success:^{
        [[AppDelegate instance] hideLoadingView];
        TrakingViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TrakingViewController"];
        ctr.order = order;
        [self.navigationController pushViewController:ctr animated:YES];
        
    } failure:^(NSError *error, NSInteger code) {
        [[AppDelegate instance] hideLoadingView];
    }];
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[Constants baseURL]]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"application/json"];
        jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        _manager.responseSerializer = jsonResponseSerializer;
    }
    
    return _manager;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
