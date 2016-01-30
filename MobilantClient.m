//
//  MobilantClient.m
//  Mobilant
//
//  Created by Daniel on 07.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MobilantClient.h"
//#import "ASIHTTPRequest.h"

@implementation MobilantClient

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(void)setAPIKey:(NSString *)apiKey {
    APIKey = apiKey;
}

-(NSString *)getCredits {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://gw.mobilant.net/credits/?key=%@", APIKey]];
    NSError *error = NULL;
    NSString *request = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    return error ? NULL : request;
}


-(NSString *)sendSMS:(NSString *)senderID phoneNumber:(NSString *)number message:(NSString *)message route:(NSInteger)route atDate:(NSDate *)date {
    
    NSString *appendroute;
    switch (route) {
        case 0: appendroute = @"lowcost";
            break;
        case 1: appendroute = @"lowcostplus";
            break;
        case 2: appendroute = @"direct";
            break;
        case 3: appendroute = @"directplus";
            break;
        default:
            return @"Please select a route";
    }
    
    NSString *URL = [NSString stringWithFormat:@"https://gw.mobilant.net/?key=%@&route=%@&message=%@&to=%@&from=%@&dlr=1", APIKey, appendroute, [message stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1250StringEncoding], number, [senderID stringByAddingPercentEscapesUsingEncoding:NSWindowsCP1250StringEncoding]];
    
    if (date) {
        if ([date timeIntervalSinceNow] > 0) {
            time_t unixTime = (time_t) [date timeIntervalSince1970];
            URL = [URL stringByAppendingString:[NSString stringWithFormat:@"&senddate=%i", unixTime]];
        }
    }
    
    if ([message length] > 160) {
        URL = [URL stringByAppendingString:@"&concat=1"];
    }
    
    
    NSLog(@"%@", URL);
    NSURL *url = [NSURL URLWithString:URL];
    NSError *error = NULL;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    int response = error ? -1 : [content intValue];

    switch (response) {
        case -1: return @"Weird things happen.";
        case 10: return @"10: Recipient number incorrect";
        case 20: return @"20: Sender ID incorrect";
        case 30: return @"30: Message incorrect";
        case 40: return @"40: Message type incorrect";
        case 50: return @"50: SMS route incorrect";
        case 60: return @"60: Check your gateway key";
        case 70: return @"70: Buy more credits";
        case 71: return @"71: Feature not possible. Choose a different route";
        case 80: return @"80: Pass to SMS-C failed. Try another route or contact support";
        case 90: return @"90: Recipient number incorrect";
        case 100: return NULL;
            default:
            return [NSString stringWithFormat:@"I don't know WTF just happened. Code: %i", response];
            break;
    }
    return NULL;
}

-(NSArray *)routes {
    return [NSArray arrayWithObjects:@"lowcost", @"lowcostplus", @"direct", @"directplus", nil];
}

-(NSUInteger)maxMessageLength {
    return 1530;
}


@end
