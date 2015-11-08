

#import "Utilities.h"
#import "ActivityIndicator.h"
#import <MoABContactsManager/MoABContactsManager.h>

@implementation Utilities

+(void)showErrorMessage:(NSString*)message target:(id)target{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:target cancelButtonTitle:NSLocalizedString(@"generic.ok", nil) otherButtonTitles:nil];
    [alert show];
}

+(void)showAlertMessage:(NSString*)message target:(id)target{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:target cancelButtonTitle:NSLocalizedString(@"generic.ok", nil) otherButtonTitles:nil];
    [alert show];
    alert = nil;
}

+(void)showAlertMessage:(NSString*)message target:(id)target alertTag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:target cancelButtonTitle:NSLocalizedString(@"generic.ok", nil) otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
    alert = nil;
    
}

+(void)showCustomAlertMessage:(NSString*)message target:(id)target alertTag:(NSInteger)tag {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"\n\n" delegate:target cancelButtonTitle:NSLocalizedString(@"generic.yes", nil) otherButtonTitles:NSLocalizedString(@"generic.no", nil),nil];
                              alertView.tag=tag;
    
    UILabel *txtField = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 20, 260.0, 40.0)];
    [txtField setFont:[UIFont fontWithName:@"Helvetica-Bold" size:(18.0)]];
    txtField.numberOfLines = 3;
    txtField.text = message ;
    txtField.textAlignment=NSTextAlignmentCenter;
    txtField.textColor=[UIColor whiteColor];
    txtField.backgroundColor = [UIColor clearColor];
    [alertView addSubview:txtField];
    [alertView show];
    
}

+(void)showios7AlertMessage:(NSString*)message target:(id)target alertTag:(NSInteger)tag{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:target
                                          cancelButtonTitle:NSLocalizedString(@"generic.yes", nil)
                                          otherButtonTitles:NSLocalizedString(@"generic.no", nil),nil];
    alert.tag = tag;
    [alert show];
    alert = nil;
    
}



+(BOOL)isValidEmail:(NSString *)email {
   
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:email];
    
}

+(BOOL)areValidPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword {
    return [password isEqualToString:confirmPassword];

}

+ (BOOL)doesFileExists:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath: path] ;
    
}

+ (NSString*)pathOfFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    return path;
}

+ (BOOL)createFile:(NSString *)fileName{
    return NO;
}

+ (BOOL)isDate:(NSDate *)date1 equalsTo:(NSDate *)date2 {
    NSInteger day1 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date1];
    NSInteger day2 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:date2];
    return day1 == day2;
}

+ (void)showPermissionDialog:(NSString *)title message:(NSString *)message target:(id)target {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:target cancelButtonTitle:@"CANCEL" otherButtonTitles:@"ADD",nil];
    alert.tag = 200;
    if ([title isEqualToString:@"ADD TO FAVORITES"]) {
//        NSArray *views = [alert subviews];
//        UIButton *btn = (UIButton*)[views objectAtIndex:3];
//        btn.backgroundColor = [UIColor redColor];
        //[btn setBackgroundImage:[UIImage imageNamed:@"send_a_message_bg_off.png"] forState:UIControlStateHighlighted];
    }
    [alert show];
    alert = nil;

}

+ (NSString*)todaysWeekDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *com = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger dayNumber = [com weekday];
    switch (dayNumber) {
        case 1:
            return @"Sun";
        case 2:
            return @"Mon";
        case 3:
            return @"Tue";
        case 4:
            return @"Wed";
        case 5:
            return @"Thu";
        case 6:
            return @"Fri";
        case 7:
            return @"Sat";
        default:
            break;
            
    }
    return nil;
    
}

+ (NSInteger)maxInArray:(NSArray *)arr {
    NSInteger max = 0;
    for (NSString *num in arr) {
        if (max < [num integerValue]) {
            max = [num integerValue];
        }
    }
    return max;
}

+ (NSInteger)getWeekDayFromAbbreviation:(NSString *)abb {
    if ([[abb lowercaseString]isEqualToString:@"sun"]) {
        return 1;
    }else if ([[abb lowercaseString]isEqualToString:@"mon"]) {
        return 2;
    }else if ([[abb lowercaseString]isEqualToString:@"tue"]) {
        return 3;
    }else if ([[abb lowercaseString]isEqualToString:@"wed"]) {
        return 4;
    }else if ([[abb lowercaseString]isEqualToString:@"thu"]) {
        return 5;
    }else if ([[abb lowercaseString]isEqualToString:@"fri"]) {
        return 6;
    }else if ([[abb lowercaseString]isEqualToString:@"sat"]) {
        return 7;
    }
    return -1;
}

+ (NSDate*)date:(NSDate *)date1 withTime:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                   fromDate:date1];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
                                                   fromDate:date2];
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    return itemDate;
}

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

+ (NSString*)getGenderAbbrebiation:(NSString *)gender {
    if ([[gender lowercaseString] isEqualToString:@"male"]) {
        return @"M";
    }
    return @"F";
}

+ (NSMutableArray *) parsingString:(NSString *) parsingString
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSRange stringRange = NSMakeRange(0, parsingString.length);
    
    NSString *searchString = [parsingString substringWithRange:stringRange];
   // NSString *_searchString = [parsingString substringWithRange:stringRange];
    
    NSRange firstRange  = [searchString rangeOfString:@" "];
    
    if (firstRange.location != NSNotFound)
    {
        NSRange searchRange = NSMakeRange(0, firstRange.location);
        NSString *parsedString = [searchString substringWithRange:searchRange];
        
        NSLog(@"parsedString:%@", parsedString);
        
        [result addObject:parsedString];
        
        NSLog(@"parsingString.length %zd", parsingString.length);
        NSLog(@"parsedString.length %zd", parsedString.length);
        
        //NSRange _searchRange = NSMakeRange(parsedString.length+1, _searchString.length);
        //NSRange _searchRange = NSMakeRange(parsedString.length+1, _searchString.length);
        
        NSRange _searchRange = NSMakeRange(0, firstRange.location);
        NSString *_parsedString = [searchString substringWithRange:_searchRange];
        
        NSLog(@"_parsedString:%@", _parsedString);
        
        [result addObject:_parsedString];
    }
    else
        stringRange.location = NSNotFound;
    
    return result;
}

-(void)showLoadingView:(UIView*)view{
   
    loadingView = [[ActivityIndicator alloc] initWithFrame:CGRectZero];
    [view addSubview:loadingView ];
    [loadingView startSpinner];
    loadingView.hidden = NO;
    [view bringSubviewToFront:loadingView];
}

-(void)hideLoadingView{
    [loadingView stopSpinner];
    [loadingView setHidden:YES];
}

+ (void)getAllContacts {
    
    [[MoABContactsManager sharedManager] contacts:^(ABAuthorizationStatus authorizationStatus, NSArray *contacts, NSError *error) {
        
        if (error) {
            
            [UIAlertView showAlertWithTitle:@"Error"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
            
        }else {
            
            if (authorizationStatus == kABAuthorizationStatusAuthorized) {
                // Do something with contacts
                //STLogDebug(@"Contacts: %@",contacts);
                
                [contacts enumerateObjectsUsingBlock:^(MoContact *contact, NSUInteger idx, BOOL * _Nonnull stop) {
                    STLogDebug(@"contact: %@",contact);
                }];
                
            }else {
                [UIAlertView showAlertWithTitle:@"Error"
                                        message:@"User didn't give permissions"
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
            }
        }
    }];
}


@end
