//
//  MobilantAppDelegate.h
//  Mobilant
//
//  Created by Daniel on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MobilantClient.h"
#import "MLFieldEditor.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABRecord.h>
#import <AddressBook/ABAddressBookC.h>
#import <AddressBook/ABGlobalsC.h>


@interface MobilantAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate> {
@private
    NSWindow *__unsafe_unretained window;
    NSSearchField *__unsafe_unretained search;
    NSProgressIndicator *__unsafe_unretained progress;
    NSButton *__unsafe_unretained selectContact;
    NSTextView *__unsafe_unretained smsText;
    NSTextField *__unsafe_unretained smsTextLength;
    NSButton *__unsafe_unretained send;
    NSPopUpButton *__unsafe_unretained smsRoute;
    NSDatePicker *__unsafe_unretained smsSendDate;
    NSTextField *__unsafe_unretained smsSenderId;
    NSTextFieldCell *__unsafe_unretained smsSenderIdCell;
    NSTextField *__unsafe_unretained apiKey;
    NSTextFieldCell *__unsafe_unretained apiKeyCell;
    NSTextField *__unsafe_unretained smsErrorMessage;
    NSButton *__unsafe_unretained details;
    NSString *from;
    
    NSScrollView *__unsafe_unretained scroll;
    
    ABAddressBook *AB;
    
    SMSClient *mobilant;
    
    BOOL errorIsShown;
    IBOutlet NSUserDefaultsController *defaults;
    
    BOOL completePosting;
    BOOL commandHandling;
    BOOL disclosed;
    
    MLFieldEditor *_mlFieldEditor;
    
    NSString *__unsafe_unretained credits;
}

-(IBAction)sendPressed:(id)sender;
-(IBAction)disclose:(id)sender;
-(void)showError:(NSString*) message;
-(void)hideError;
-(void)sendAnimation:(id)sendInProgress;

-(void)textDidChange:(NSNotification *)aNotification;
-(IBAction)updateFilter:sender;
-(void)controlTextDidChange:(NSNotification *)obj;
-(NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int*)index;
-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector;
-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)app;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSearchField *search;
@property (assign) IBOutlet NSProgressIndicator *progress;
@property (assign) IBOutlet NSButton *selectContact;
@property (assign) IBOutlet NSTextView *smsText;
@property (assign) IBOutlet NSTextField *smsTextLength;
@property (assign) IBOutlet NSButton *send;
@property (assign) IBOutlet NSPopUpButton *smsRoute;
@property (assign) IBOutlet NSDatePicker *smsSendDate;
@property (assign) IBOutlet NSTextField *smsSenderId;
@property (assign) IBOutlet NSTextField *apiKey;
@property (assign) IBOutlet NSTextField *smsErrorMessage;
@property (assign) IBOutlet NSButton *details;
@property (assign) IBOutlet NSScrollView *scroll;
@property (assign) NSString *credits;
@property (assign) IBOutlet NSTextFieldCell *smsSenderIdCell;
@property (assign) IBOutlet NSTextFieldCell *apiKeyCell;

@end
