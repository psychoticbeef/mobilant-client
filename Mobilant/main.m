//
//  main.m
//  Mobilant
//
//  Created by Daniel on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "validatereceipt.h"

const NSString * global_bundleVersion = @"1.1";
const NSString * global_bundleIdentifier = @"de.3dannalt.Mobilant";


int main(int argc, char *argv[])
{
    @autoreleasepool {
    
        NSString * pathToReceipt = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/_MASReceipt/receipt"];
    
//    if (!validateReceiptAtPath(pathToReceipt))
//        exit(173);
    
    }    return NSApplicationMain(argc, (const char **)argv);
}
