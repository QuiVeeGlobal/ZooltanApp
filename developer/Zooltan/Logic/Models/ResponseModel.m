//
//  ResponseModel.m
//  Experts
//
//  Created by Eugene Vegner on 17.09.14.
//  Copyright (c) 2014 Grigoriy Zaliva. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel

- (id)initWithResponseData:(id)responseData
{
	self = [super init];
	if (self != nil)
    {
        if (!responseData)
        {
            //self.code = ServerCodeNoInternet;
            self.data = nil;
        }
        else
        {
            if ([responseData isKindOfClass:NSDictionary.class])
            {
                //STLogInfo(@"Parse responseData as NSDictionary");
                @try
                {
                    self.data = responseData[@"results"];
                    self.status = responseData[@"status"];
                }
                @catch (NSException *exception) { STLogException(exception); }
            }
            else if ([responseData isKindOfClass:NSData.class])
            {
                //STLogInfo(@"Parse responseData as NSData");
                @try {
                    NSError* error;
                    NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                options:kNilOptions
                                                                                  error:&error];
                    if (!error && responseDic)
                    {
                        self.data = responseDic[@"results"];
                        self.status = responseData[@"status"];
                    }
                }
                @catch (NSException *exception) { STLogException(exception); }
            }
        }
	}
	return self;
}

@end
