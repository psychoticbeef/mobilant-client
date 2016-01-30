//
//  SMSClient.m
//  Mobilant
//
//  Created by Daniel on 07.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SMSClient.h"


@implementation SMSClient

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



-(void)setAPIKey:(NSString*)apiKey {
    
}
-(NSString *)getCredits {
    return NULL;
}
-(NSString *)sendSMS:(NSString *)senderID phoneNumber:(NSString *)number message:(NSString *)message route:(NSInteger)route atDate:(NSDate *)date {
    return NULL;
}
-(NSArray *)routes {
    return NULL;
}
-(NSUInteger)maxMessageLength {
    return 0;
}

@end
