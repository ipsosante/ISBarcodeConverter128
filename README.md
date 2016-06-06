# ISBarcodeConverter128
Convert data to be displayed in a code 128 barcode.

Objective-C port of [http://www.jtbarton.com/Barcodes/Code128.aspx](http://www.jtbarton.com/Barcodes/Code128.aspx).

## Usage

Import the converter class:

    #import "ISBarcodeConverter128.h"

Convert your data into a string usable with the code 128 font:

    NSString *barcode = [ISBarcodeConverter128 stringToBarcode:@"the lazy dog"];
    // Barcode can now be displayed in a UILabel (for example) with a code 128 font


## Code 128 font

You can use this font for free: [http://www.jtbarton.com/Barcodes/code128.ttf](http://www.jtbarton.com/Barcodes/code128.ttf)

## Acknowledgement

A big thank you to [John T. Barton](http://www.jtbarton.com/) for his [initial C# implementation of this converter](http://www.jtbarton.com/Barcodes/Code128.aspx), and letting us use and redistribute it with modifications. 🙌