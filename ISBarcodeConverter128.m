//
//  ISBarcodeConverter128.m
//
//  Created by Guillaume Algis on 03/06/2016.
//  Copyright © 2016 ipso santé. All rights reserved.
//
// Adapted from original implementation of John Barton
// http://www.jtbarton.com/Barcodes/BarcodeStringBuilderExample.aspx
//

#import "ISBarcodeConverter128.h"

@implementation ISBarcodeConverter128

+ (nullable NSString *)stringToBarcode:(NSString *)value
{
    if (value.length <= 0) {
        return nil;
    }

    // Check for valid characters
    for (NSUInteger charCount = 0; charCount < value.length; charCount++)
    {
        unichar currentChar = [value characterAtIndex:charCount];
        if (!(currentChar >= 32 && currentChar <= 126))
        {
            return nil;
        }
    }

    NSMutableString *returnValue = [NSMutableString string];
    BOOL isTableB = YES;

    NSUInteger charPos = 0;
    NSInteger minCharPos = 0;
    unichar currentChar = 0;

    while (charPos < value.length) {
        if (isTableB) {
            // See if interesting to switch to table C
            // yes for 4 digits at start or end, else if 6 digits
            if (charPos == 0 || charPos + 4 == value.length) {
                minCharPos = 4;
            }
            else {
                minCharPos = 6;
            }

            minCharPos = [[self class] isNumber:value charPosition:charPos minCharPosition:minCharPos];

            if (minCharPos < 0)
            {
                // Choice table C
                if (charPos == 0)
                {
                    // Starting with table C
                    unichar c = 205;
                    returnValue = [NSMutableString stringWithCharacters:&c length:1];
                }
                else
                {
                    // Switch to table C
                    unichar c = 199;
                    [returnValue appendString:[NSString stringWithCharacters:&c length:1]];
                }
                isTableB = NO;
            }
            else
            {
                if (charPos == 0)
                {
                    // Starting with table B
                    unichar c = 204;
                    returnValue = [NSMutableString stringWithCharacters:&c length:1];
                }

            }
        }

        if (!isTableB)
        {
            // We are on table C, try to process 2 digits
            minCharPos = 2;
            minCharPos = [[self class] isNumber:value charPosition:charPos minCharPosition:minCharPos];
            if (minCharPos < 0) // OK for 2 digits, process it
            {
                currentChar = (unichar)[[value substringWithRange:NSMakeRange(charPos, 2)] intValue];
                currentChar = currentChar < 95 ? currentChar + 32 : currentChar + 100;
                [returnValue appendString:[NSString stringWithCharacters:&currentChar length:1]];
                charPos += 2;
            }
            else
            {
                // We haven't 2 digits, switch to table B
                unichar c = 200;
                [returnValue appendString:[NSString stringWithCharacters:&c length:1]];
                isTableB = YES;
            }
        }
        if (isTableB)
        {
            // Process 1 digit with table B
            [returnValue appendString:[value substringWithRange:NSMakeRange(charPos, 1)]];
            charPos++;
        }
    }

    // Calculation of the checksum
    unichar checksum = 0;
    for (NSUInteger loop = 0; loop < returnValue.length; loop++)
    {
        currentChar = [returnValue characterAtIndex:loop];
        currentChar = currentChar < 127 ? currentChar - 32 : currentChar - 100;
        if (loop == 0) {
            checksum = currentChar;
        }
        else {
            checksum = (checksum + (loop * currentChar)) % 103;
        }
    }

    // Calculation of the checksum ASCII code
    checksum = checksum < 95 ? checksum + 32 : checksum + 100;
    // Add the checksum and the STOP
    [returnValue appendString:[NSString stringWithCharacters:&checksum length:1]];
    unichar c = 206;
    [returnValue appendString:[NSString stringWithCharacters:&c length:1]];


    return returnValue;
}


+ (NSInteger)isNumber:(NSString *)inputValue charPosition:(NSUInteger)charPos minCharPosition:(NSInteger)minCharPos
{
    // if the minCharPos characters from charPos are numeric, then minCharPos = -1
    minCharPos--;
    if (charPos + minCharPos < inputValue.length) {
        while (minCharPos >= 0) {
            unichar c = [inputValue characterAtIndex:(charPos + minCharPos)];
            if (c < 48 || c > 57) {
                break;
            }
            minCharPos--;
        }
    }
    return minCharPos;
}

@end
