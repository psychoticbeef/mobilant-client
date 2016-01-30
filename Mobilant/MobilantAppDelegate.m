//
//  MobilantAppDelegate.m
//  Mobilant
//
//  Created by Daniel on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MobilantAppDelegate.h"
#import <Quartz/Quartz.h>
//#import "ASIHTTPRequest.h"

@implementation MobilantAppDelegate

@synthesize window;
@synthesize search, progress, selectContact, smsText, smsTextLength, send, smsRoute, smsSendDate, smsSenderId, apiKey, smsErrorMessage, details, scroll;
@synthesize credits, smsSenderIdCell, apiKeyCell;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    AB = [ABAddressBook sharedAddressBook];
    [window setMaxSize:NSMakeSize(FLT_MAX, [window frame].size.height)];
    [window setMinSize:NSMakeSize(319, [window frame].size.height)];
    [smsSendDate setDateValue:[NSDate date]];
    errorIsShown = NO;
    mobilant = [[MobilantClient alloc] init];
    [mobilant setAPIKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"APIKey"]];
    NSMutableArray *intermediate = [[mobilant routes] mutableCopy];
    [intermediate removeObjectsInArray:[smsRoute itemArray]];
    if ([intermediate count] > 0) {
        [smsRoute removeAllItems];
        [smsRoute addItemsWithTitles:[mobilant routes]];
    }
    [smsRoute selectItemAtIndex:[[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedRoute"] intValue]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.credits = [mobilant getCredits];
    });
    if ([@"" isEqualToString:smsSenderId.stringValue]) {
        smsSenderIdCell.placeholderString = @"Sender ID";
    }
    if ([@"" isEqualToString:apiKey.stringValue])
        apiKeyCell.placeholderString = @"Gateway Key";
}


-(void)showError:(NSString*) message {
    if (errorIsShown) {
        return;
    }
    errorIsShown = YES;
    [smsErrorMessage setStringValue:message];
    NSRect frame = [scroll frame];
    frame.size.height -= 33;
    frame.origin.y += 33;
    [[scroll animator] setFrame:frame];
}


-(void)hideError {
    if (!errorIsShown) {
        return;
    }
    errorIsShown = NO;
    NSRect frame = [scroll frame];
    frame.size.height += 33;
    frame.origin.y -= 33;
    [[scroll animator] setFrame:frame];
}


-(void)sendPressed:(id)sender {
    [mobilant setAPIKey:[apiKey stringValue]];
    NSString *recipientNumber = [search stringValue];

    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    recipientNumber = [recipientNumber stringByTrimmingCharactersInSet:nonDigits];
    
    [self performSelectorOnMainThread:@selector(sendAnimation:) withObject:self waitUntilDone:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *error = [mobilant sendSMS:[smsSenderId stringValue] phoneNumber:recipientNumber message:[smsText string] route:[smsRoute indexOfSelectedItem] atDate:[smsSendDate dateValue]];
        if (error) {
            [self performSelectorOnMainThread:@selector(showError:) withObject:error waitUntilDone:NO];
        } else {
            [self hideError];
        }
        [self performSelector:@selector(sendAnimation:) withObject:NULL afterDelay:0.5];
        self.credits = [mobilant getCredits];
    });
}


-(NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int*)index {
    NSString *searchString = [search stringValue];
    ABSearchElement *nameIsSmith = [ABPerson searchElementForProperty:nil label:nil key:nil value:searchString comparison:kABEqualCaseInsensitive];
    NSArray *peopleFound = [AB recordsMatchingSearchElement:nameIsSmith];

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id person in peopleFound) {
        NSString *firstName = [person valueForProperty:kABFirstNameProperty];
        NSString *lastName = [person valueForProperty:kABLastNameProperty];
        ABMultiValue *phoneNumbers = [person valueForProperty:kABPhoneProperty];
        if ([phoneNumbers count] <= 0)
            continue;
        if (!firstName)
            firstName = @"";
        if (!lastName)
            lastName = @"";
        for (int i = 0; i < [phoneNumbers count]; i++) {
            NSString *label = [phoneNumbers labelAtIndex:i];
            if (!label)
                label = @"";
            label = [label stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            label = [label stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            NSString *number = [[phoneNumbers valueAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (!number)
                number = @"";
            [arr addObject:[NSString stringWithFormat:@"%@ %@ (%@ %@)", firstName, lastName, label, number]];
        }
        
    }
    
    [arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [arr insertObject:[[textView string] substringWithRange:charRange] atIndex: 0];
    
	return arr;
}


-(void)textDidChange:(NSNotification *)aNotification {
    unsigned long maxlen;
    unsigned long textlen = [[smsText string] length];

    [smsTextLength setTextColor:[NSColor blackColor]];

    if (textlen <= 160) {
        maxlen = 160;
    } else {
        maxlen = textlen / 153;
        if (textlen % 153 != 0)
            maxlen++;
        maxlen *= 153;

        if (maxlen > [mobilant maxMessageLength]) {
            maxlen = [mobilant maxMessageLength];
            [smsTextLength setTextColor:[NSColor redColor]];
        }
    }
    
    [smsTextLength setStringValue:[NSString stringWithFormat:@"%i/%i", textlen, maxlen]];
    
    [defaults save:self];
    [self hideError];
}


-(id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)client {
    if ([client isKindOfClass:[NSSearchField class]]) {
        if (!_mlFieldEditor) {
            _mlFieldEditor = [[MLFieldEditor alloc] init];
            [_mlFieldEditor setFieldEditor:YES];
        }
        return _mlFieldEditor;
    }
    return nil;
}


-(void)disclose:(id)sender {
    int delta;
    NSRect frame = [window frame];

    if (!disclosed) {
        disclosed = YES;
        delta = 80;
        frame.origin.y -= delta;
    } else {
        disclosed = NO;
        delta = 0;
        frame.origin.y += 80;
    }

    frame.size.height = 271 + delta;
    
//    [window setMaxSize:NSMakeSize(FLT_MAX, [window frame].size.height + delta)];
//    [window setMinSize:NSMakeSize(319, [window frame].size.height + delta)];
    [window setMaxSize:NSMakeSize(FLT_MAX, 271 + delta)];
    [window setMinSize:NSMakeSize(319, 271 + delta)];
    [[window animator] setFrame:frame display:YES];
}


-(void)sendAnimation:(id)sendInProgress {
    NSRect frame = [[search animator] frame];

    if (sendInProgress) {
        [progress performSelector:@selector(startAnimation:) withObject:self afterDelay:0.1];
        frame.size.width -= 24;
    } else {
        [progress performSelector:@selector(stopAnimation:) withObject:self afterDelay:0.1];
        frame.size.width += 24;
    }

    [[search animator] setFrame:frame];
}


-(IBAction)updateFilter:sender {
}


-(void)controlTextDidChange:(NSNotification *)obj {
    NSTextView * fieldEditor = [[obj userInfo] objectForKey:@"NSFieldEditor"];
    if (!completePosting && !commandHandling) {
        completePosting = YES;
        [fieldEditor complete:self];
        completePosting = NO;
    }
}


-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
	
	if ([textView respondsToSelector:commandSelector]) {
        commandHandling = YES;
        [textView performSelector:commandSelector withObject:nil];
        commandHandling = NO;
		
		result = YES;
    }
	
    return result;
}


-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)app {
    [defaults save:self];
    return NSTerminateNow;
}


@end