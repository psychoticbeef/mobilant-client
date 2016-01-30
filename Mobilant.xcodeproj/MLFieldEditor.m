//
//  MLFieldEditor.m
//  Mobilant
//
//  Created by Daniel on 09.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MLFieldEditor.h"


//
//  MLFieldEditor.m
//  Mobilant
//
//  Created by Daniel on 09.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@implementation MLFieldEditor


-  (void)insertCompletion:(NSString *)word forPartialWordRange:(NSRange)charRange movement:(NSInteger)movement isFinal:(BOOL)flag
{
    // suppress completion if user types a space
    if (movement == NSRightTextMovement) return;
    
    // show full replacements
    if (charRange.location != 0) {
        charRange.length += charRange.location;
        charRange.location = 0;
    }
    
    [super insertCompletion:word forPartialWordRange:charRange movement:movement isFinal:flag];
    
    if (movement == NSReturnTextMovement)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MLSearchFieldAutocompleted" object:self userInfo:nil];
    }
}

@end