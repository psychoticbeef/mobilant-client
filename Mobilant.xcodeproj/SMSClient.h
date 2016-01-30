//
//  SMSClient.h
//  Mobilant
//
//  Created by Daniel on 07.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#pragma mark abstract

#import <Foundation/Foundation.h>

@protocol SMSClientProtocol
-(void)setAPIKey:(NSString*)apiKey;
-(NSString *)getCredits;
-(int)sendSMS:(NSString *)senderID phoneNumber:(NSString *)number message:(NSString *)message route:(NSInteger)route atDate:(NSDate *)date;
-(NSArray *)routes;
-(NSUInteger)maxMessageLength;
@end

@interface SMSClient : NSObject <SMSClientProtocol> {
@private
    
}

-(void)setAPIKey:(NSString*)apiKey;
-(NSString *)getCredits;
-(NSString *)sendSMS:(NSString *)senderID phoneNumber:(NSString *)number message:(NSString *)message route:(NSInteger)route atDate:(NSDate *)date;
-(NSArray *)routes;
-(NSUInteger)maxMessageLength;

@end
