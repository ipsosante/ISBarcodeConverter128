//
//  ISBarcodeConverter128.h
//
//  Created by Guillaume Algis on 03/06/2016.
//  Copyright © 2016 ipso santé. All rights reserved.
//
// Adapted from original implementation of John Barton
// http://www.jtbarton.com/Barcodes/BarcodeStringBuilderExample.aspx
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ISBarcodeConverter128 : NSObject

/// Converts an input string to the equivilant string, that need to be produced using the 'Code 128' font.
/// @param value String to be encoded
/// @return Encoded string start/stop and checksum characters included
+ (nullable NSString *)stringToBarcode:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
