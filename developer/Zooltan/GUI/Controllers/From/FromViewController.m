//
//  ViewController.m
//  Zooltan
//
//  Created by Grigoriy Zaliva on 6/22/15.
//  Copyright (c) 2015 Grigoriy Zaliva. All rights reserved.


#import "FromViewController.h"
#import "HistoryViewController.h"
#import "SocialManager.h"
#import "AdressCell.h"

#import "CreateViewController.h"

#define keyboardHeight 260
#define durationAnimation 0.3f
#define border_Width 1
#define layerCornerRadius 2.5;
#define kIconSize 20
#define delay 0.55f

@interface FromViewController () <UIScrollViewDelegate, TextFieldButtonDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AdressCelllDelegate>
{
    TextField *serchField;
    NSArray *placesArray;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, retain) PlaceModel *homeAddress;
@property (nonatomic, retain) PlaceModel *workAddress;
@property (nonatomic, retain) PlaceModel *fromAddress;
@property (nonatomic, retain) PlaceModel *toAddress;
@property (nonatomic, retain) PlaceModel *destinationAddress;

@end

@implementation FromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.homeAddress = [[Settings instance] homeAddress];
    self.workAddress = [[Settings instance] workAddress];
    
    if (self.homeAddress.formatted_address == nil) {
        [self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
        [[self.segmentedControl.subviews objectAtIndex:1] setTintColor:[UIColor lightGrayColor]];
    }
    if (self.workAddress.formatted_address == nil) {
        [self.segmentedControl setEnabled:NO forSegmentAtIndex:1];
        [[self.segmentedControl.subviews objectAtIndex:0] setTintColor:[UIColor lightGrayColor]];
    }
}

- (void)getPlaceByString
{
    [[Server instance] GMSSearchPlace:serchField.text success:^(NSArray *places_rray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            placesArray = places_rray;
            [self.tableView reloadData];
        });

    } failure:nil];
}

- (void)configureView
{
    [super configureView];
    
    if (self.callController == Create)
        self.segmentedControl.hidden = NO;
    else
        self.segmentedControl.hidden = YES;
    
    if (self.addressType == HomeAddress)
        self.navItem.title = NSLocalizedString(@"ctrl.from.segmented.title1", nil);
    else if (self.addressType == WorkAddress)
        self.navItem.title = NSLocalizedString(@"ctrl.from.segmented.title2", nil);
    else if (self.addressType == FromAddress)
        self.navItem.title = NSLocalizedString(@"ctrl.from.navigation.title", nil);
    else if (self.addressType == ToAddress)
        self.navItem.title = NSLocalizedString(@"ctrl.to.navigation.title", nil);
    else if (self.addressType == DestinationAddress)
        self.navItem.title = NSLocalizedString(@"ctrl.destination.navigation.title", nil);
    
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.from.segmented.title1", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"ctrl.from.segmented.title2", nil) forSegmentAtIndex:1];
    
    self.segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.segmentedControl.backgroundColor = [Colors clearColor];
    self.segmentedControl.tintColor = [Colors yellowColor];
    
    [self addCornerRadius:serchField];
}

- (void) addCornerRadius:(UIView *) view
{
    view.layer.cornerRadius = layerCornerRadius;
    view.clipsToBounds = YES;
}

- (void) setTextColor:(TextField *) textField
{
    textField.tintColor = [Colors yellowColor];
    
    textField.textColor = [Colors darkGrayColor];
    [textField setValue:[Colors darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void) addBottomLineInTextFild:(TextField *) textFild
{
    textFild.textColor = [UIColor lightGrayColor];
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor lightGrayColor].CGColor;
    border.frame = CGRectMake(0, textFild.height+4, textFild.width, textFild.height);
    border.borderWidth = borderWidth;
    [textFild.layer addSublayer:border];
    textFild.clipsToBounds = YES;
    textFild.layer.masksToBounds = YES;
}

- (void) scrollRectToVisible:(CGRect) rect
{
    [self performBlock:^{
        [self.scrollView scrollRectToVisible:rect animated:YES];
    } afterDelay:durationAnimation];
}

- (UIView *) setHeaderView
{
    if (!serchField)
    {
        serchField = [[TextField alloc] init];
        serchField.frame = CGRectMake(0, 0, self.tableView.width, 35);
        serchField.delegate = self;
        serchField.font = [Fonts setOpenSansWithFontSize:14];
        serchField.textColor = [Colors lightGrayColor];
        serchField.tintColor = [Colors yellowColor];
        serchField.layer.borderColor = [Colors lightGrayColor].CGColor;
        serchField.layer.borderWidth = border_Width;
        serchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        serchField.returnKeyType = UIReturnKeyDone;
        serchField.placeholder = NSLocalizedString(@"ctrl.from.placeholder.serach", nil);
        serchField.edgeInsets = UIEdgeInsetsMake(0, kIconSize+15, 0, 0);
        [serchField addSubview:[self setIconWithImage:[UIImage imageNamed:@"searchIcon"]frame:CGRectMake(10, serchField.height/2-kIconSize/2, kIconSize, kIconSize)]];
        
        if (self.contact) {
            serchField.text = self.contact.addressInfo;
            [self getPlaceByString];
        }
        
        [self addCornerRadius:serchField];
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                         target:self
                                                                                         action:@selector(cancelAction)];
        
        keyboardToolbar.items = @[cancelBarButton];
        [keyboardToolbar setTintColor:[UIColor blackColor]];
        [keyboardToolbar sizeToFit];
        serchField.inputAccessoryView = keyboardToolbar;
        
        [serchField addTarget:self action:@selector(searchFieldDidChangeValue)
             forControlEvents:UIControlEventEditingChanged];

    }
    
    return serchField;
}

- (UIImageView *) setIconWithImage:(UIImage *) image frame:(CGRect) frame
{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = image;
    icon.frame = frame;
    
    return icon;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return placesArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    AdressCell *cell = [tableView dequeueReusableCellWithIdentifier:AdressCell.className
                                                       forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (indexPath.row == 0)
        cell.titleLabel.text = NSLocalizedString(@"ctrl.from.title.current_location", nil);
    else
    {
        PlaceModel *palceModel = placesArray[indexPath.row-1];
        cell.titleLabel.text = palceModel.formatted_address;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STLogMethod;
}

- (void)adressCellDidPressButton:(UIButton *)button
                     atIndexPath:(NSIndexPath *)indexPath
{
    [[AppDelegate instance] showLoadingView];
    
    STLogMethod;
    STLogDebug(@"indexPath: %@",indexPath);
    
    
    if (indexPath.row != 0)
    {
        PlaceModel *placeModel = placesArray[indexPath.row-1];
        STLogDebug(@"placesArray: %@",placesArray);
        
        [[Server instance] GMSUpdatePlace:placeModel success:^{
            
            STLogDebug(@"placeModel: %@",placeModel);
            
            if (self.addressType == HomeAddress)
                [[Settings instance] setHomeAddress:placeModel];
            else if (self.addressType == WorkAddress)
                [[Settings instance] setWorkAddress:placeModel];
            else if (self.addressType == FromAddress)
                [[Settings instance] setFromAddress:placeModel];
            else if (self.addressType == ToAddress)
                [[Settings instance] setToAddress:placeModel];
            else if (self.addressType == DestinationAddress)
                [[Settings instance] setDestinationAddress:placeModel];
            
            [[AppDelegate instance] hideLoadingView];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error, NSInteger code) {
            [[AppDelegate instance] hideLoadingView];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
    else
    {
        STLogDebug(@"|------");
        [[Server instance] GMSCurrentPlaceSuccess:^(NSArray *places) {
            PlaceModel *place = places.firstObject;
            serchField.text = place.formatted_address;
            
            STLogDebug(@"|Place: %@",place);
            
            placesArray = places;
            [self.tableView reloadData];
            [[AppDelegate instance] hideLoadingView];

        } failure:^(NSError *error, NSInteger code) {
            // Can't find current location
            STLogDebug(@"Can't find current location");
            [[AppDelegate instance] hideLoadingView];
        }];
    }

    
//    if (indexPath.row != 0)
//    {
//        PlaceModel *placeModel = placesArray[indexPath.row-1];
//        
//        if (self.addressType == HomeAddress)
//            [[Settings instance] setHomeAddress:placeModel];
//        else if (self.addressType == WorkAddress)
//            [[Settings instance] setWorkAddress:placeModel];
//        else if (self.addressType == FromAddress)
//            [[Settings instance] setFromAddress:placeModel];
//        else if (self.addressType == ToAddress)
//            [[Settings instance] setToAddress:placeModel];
//        else if (self.addressType == DestinationAddress)
//            [[Settings instance] setDestinationAddress:placeModel];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        CLLocation *currentLocation = [[AppDelegate instance] currentLocation];
//        
//        PlaceModel *placeModel = [PlaceModel new];
//        
//        placeModel.formatted_address = [[AppDelegate instance] currentAdrees];
//        placeModel.location = currentLocation.coordinate;
//        
//        serchField.text = placeModel.formatted_address;
//        [serchField becomeFirstResponder];
//    }
}

#pragma mark - IBAction
#pragma mark -

//- (void)clearAction
//{
//    serchField.text = nil;
//    CLLocation *currentLocation = [[AppDelegate instance] currentLocation];
//    
//    PlaceModel *placeModel = [PlaceModel new];
//    
//    placeModel.formatted_address = serchField.text;
//    placeModel.location = currentLocation.coordinate;
//    
//    if (self.addressType == HomeAddress)
//        [[Settings instance] setHomeAddress:placeModel];
//    else if (self.addressType == WorkAddress)
//        [[Settings instance] setWorkAddress:placeModel];
//    else if (self.addressType == FromAddress)
//        [[Settings instance] setFromAddress:placeModel];
//    else if (self.addressType == ToAddress)
//        [[Settings instance] setToAddress:placeModel];
//    else if (self.addressType == DestinationAddress)
//        [[Settings instance] setDestinationAddress:placeModel];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)cancelAction
{
    [serchField resignFirstResponder];
}

- (IBAction)segmentAction:(UISegmentedControl *)sender
{
    PlaceModel *from = [[Settings instance] homeAddress];
    PlaceModel *to = [[Settings instance] workAddress];
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            if (self.addressType == FromAddress)
                [[Settings instance] setFromAddress:from];
            else if (self.addressType == ToAddress)
                [[Settings instance] setToAddress:from];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case 1:
            if (self.addressType == FromAddress)
                [[Settings instance] setFromAddress:to];
            else if (self.addressType == ToAddress)
                [[Settings instance] setToAddress:to];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
#pragma mark -

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)searchFieldDidChangeValue {
    NSLog(@"textFieldDidChangeValue: %@",serchField.text);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getPlaceByString];
    });
}


@end
