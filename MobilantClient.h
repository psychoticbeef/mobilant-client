//
//  MobilantClient.h
//  Mobilant
//
//  Created by Daniel on 07.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSClient.h"


@interface MobilantClient : SMSClient <SMSClientProtocol> {
@private
    NSString *APIKey;
}

-(void)setAPIKey:(NSString*)apiKey;
-(NSString *)getCredits;
-(NSString *)sendSMS:(NSString *)senderID phoneNumber:(NSString *)number message:(NSString *)message route:(NSInteger)route atDate:(NSDate *)date;
-(NSArray *)routes;
-(NSUInteger)maxMessageLength;


@end
