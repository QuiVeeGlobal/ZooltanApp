//
//  ContactsViewController.m
//  Zooltan
//
//  Created by Eugene on 20.10.15.
//  Copyright © 2015 Grigoriy Zaliva. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactViewCell.h"
#import "CreateViewController.h"
#import <MoABContactsManager/MoABContactsManager.h>

#define border_Width 1
#define kIconSize 20
#define layerCornerRadius 2.5;

@interface ContactsViewController () <UITableViewDataSource, ContactViewCellDelegate, UITableViewDelegate, UITextFieldDelegate, TextFieldButtonDelegate, MoABContactsManagerDelegate>
{
    TextField *searchField;
}

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *filteredContacts;
@property (strong, nonatomic) MoContact *selectedContact;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MoABContactsManager sharedManager] setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES]]];
    [[MoABContactsManager sharedManager] setFieldsMask:MoContactFieldFirstName | MoContactFieldLastName | MoContactFieldPhones | MoContactFieldThumbnailProfilePicture | MoContactFieldAddress];
    [[MoABContactsManager sharedManager] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadContacts];
}

- (UIView *)setHeaderView
{
    if (!searchField)
    {
        searchField = [[TextField alloc] init];
        searchField.frame = CGRectMake(0, 0, self.tableView.width, 35);
        searchField.delegate = self;
        searchField.font = [Fonts setOpenSansWithFontSize:14];
        searchField.backgroundColor = [Colors whiteColor];
        searchField.textColor = [Colors lightGrayColor];
        searchField.tintColor = [Colors yellowColor];
        searchField.layer.borderColor = [Colors lightGrayColor].CGColor;
        searchField.layer.borderWidth = border_Width;
        searchField.edgeInsets = UIEdgeInsetsMake(0, kIconSize+15, 0, 0);
        searchField.placeholder = NSLocalizedString(@"Name or phone", nil);
        //serchField.returnKeyType = UIReturnKeySearch;
        searchField.returnKeyType = UIReturnKeyDone;
        [searchField addSubview:[self setIconWithImage:[UIImage imageNamed:@"searchIcon"]frame:CGRectMake(10, searchField.height/2-kIconSize/2, kIconSize, kIconSize)]];
        
        [self addCornerRadius:searchField];
        
        searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                         target:self
                                                                                         action:@selector(cancelAction)];
        
        keyboardToolbar.items = @[cancelBarButton];
        [keyboardToolbar setTintColor:[UIColor blackColor]];
        [keyboardToolbar sizeToFit];
        searchField.inputAccessoryView = keyboardToolbar;
        
        [searchField addTarget:self action:@selector(searchFieldDidChangeValue)
              forControlEvents:UIControlEventEditingChanged];
    }
    
    return searchField;
}

- (UIImageView *)setIconWithImage:(UIImage *)image frame:(CGRect)frame
{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = image;
    icon.frame = frame;
    
    return icon;
}

- (void)addCornerRadius:(UIView *)view
{
    view.layer.cornerRadius = layerCornerRadius;
    view.clipsToBounds = YES;
}

#pragma mark - Load Contacs

- (void)loadContacts
{
    [[MoABContactsManager sharedManager] contacts:^(ABAuthorizationStatus authorizationStatus, NSArray *contacts, NSError *error) {
        
        if (error)
            NSLog(@"Error = %@", [error localizedDescription]);
        else {
            if (authorizationStatus == kABAuthorizationStatusAuthorized) {
                _contacts = contacts;
                [self.tableView reloadData];
            }
            else
                NSLog(@"No permissions!");
        }
    }];
}

#pragma mark - MoABContactsManagerDelegate

- (BOOL)moABContatsManager:(MoABContactsManager *)contactsManager shouldIncludeContact:(MoContact *)contact
{
    return YES;
}

#pragma mark - UITableView Delegate

- (NSArray *)tableSorce
{
    if (searchField.text.length) {
        return self.filteredContacts;
    }
    return self.contacts;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContactViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableSorce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactViewCell.className
                                                            forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    MoContact *contact = self.tableSorce[indexPath.row];
    
    cell.name.text = contact.fullName;
    
    if (contact.thumbnailProfilePicture)
        cell.photo.image = contact.thumbnailProfilePicture;
    else
        cell.photo.image = [UIImage imageNamed:@"no_image"];
    
    if ([contact.phonesValues count] > 0)
        cell.phone.text = [NSString stringWithFormat:@"%@", contact.phonesValues[0]];
    else
        cell.phone.text = @"";
    
    return cell;
}

- (void)contactViewCellDelegateDidPressButton:(UIButton *)button
                                  atIndexPath:(NSIndexPath *)indexPath
{
    self.selectedContact = [self tableSorce][indexPath.row];
    
    CreateViewController *ctr = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateViewController"];
    ctr.contact = self.selectedContact;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:ctr animated:NO];

}

#pragma mark - IBAction
#pragma mark -

- (void) cancelAction
{
    [self lowerKeyboard];
}

- (void) lowerKeyboard
{
    [searchField resignFirstResponder];
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

- (void)searchFieldDidChangeValue
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.fullName contains[cd] %@ || self.phonesNumbers contains[cd] %@",
                              searchField.text,
                              searchField.text];
    self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
    
    [searchField becomeFirstResponder];
}

@end
