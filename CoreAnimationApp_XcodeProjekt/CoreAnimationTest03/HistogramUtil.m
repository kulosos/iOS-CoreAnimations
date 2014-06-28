//
//  HistogramUtil.m
//  TestApp
//
//  Created by Steffen on 21.12.13.
//  Copyright (c) 2013 Steffen. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "HistogramUtil.h"

@implementation HistogramUtil

typedef struct{
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
} MyColor;

+ (CGFloat) convertToGrayscaleFromRGB: (MyColor) color{
    return (0.299 * (float) color.red + 0.587 * (float) color.green + 0.113 * (float) color.blue);
}

+ (unsigned int) calculateIncValueForImage: (UIImage*) image{
    
    unsigned int out = ((int) (image.size.width * image.size.height)) / 100000 + 1;
    
    // if ...
    
    return out;
}

+ (NSMutableArray*) calculateIntensityHistogramOfImage: (UIImage*) image andLowpass: (int) size{
    int inc = [HistogramUtil calculateIncValueForImage: image];
    return [HistogramUtil calculateIntensityHistogramOfImage: image withInc: inc andLowpass: 1];
}
    
+ (NSMutableArray*) calculateIntensityHistogramOfImage: (UIImage*) image withInc: (int) inc andLowpass: (int) size{
    
    // inc: higher = faster but less percise
    
    if (image == Nil){
        NSLog(@"no image provided!");
        return NULL;
    }
    
    if(inc < 1 || inc > 256){
        inc = 1;
        NSLog(@"\nWarning: inc was set to ‘1‘");
    }
    
    static int maxValue = 255;
    NSMutableArray* out = [[NSMutableArray alloc] init];
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    // loop variables
    int tmpPixelInfo = 0;
    MyColor tmpColor;
    NSInteger tmpCurrentPos = 0;
    NSInteger tmpNewValue = 0;
    
    // init with zeros
    for(int i = 0; i <= maxValue; i++) [out addObject:@0];
    
    // fill histogram array
    for(int y = 0; y < (int) image.size.height; y = y + inc){
        for(int x = 0; x < (int) image.size.width; x = x + inc){
            
            tmpPixelInfo = ((image.size.width  * y) + x ) * 4;
            
            tmpColor.red    = (unsigned char) data[tmpPixelInfo];
            tmpColor.green  = (unsigned char) data[tmpPixelInfo + 1];
            tmpColor.blue   = (unsigned char) data[tmpPixelInfo + 2];
            tmpColor.alpha  = (unsigned char) data[tmpPixelInfo + 3];
            
            tmpCurrentPos = (NSUInteger) [HistogramUtil convertToGrayscaleFromRGB:tmpColor];

            tmpNewValue = [[out objectAtIndex:tmpCurrentPos] intValue] + 1;
            
            [out replaceObjectAtIndex:tmpCurrentPos withObject:[NSNumber numberWithInt: tmpNewValue]];
        }
    }
/*
    // lowpass implementation
    if((size > 2 && size < 16) && (size % 2 != 0)){
        for(int i = size; i < [out count] - size; i++){
        
        }
    }else{
        NSLog(@"calculateIntensityHistogramOfImage ... : !(size > 2 || size < 16) && (size %% 2 != 0))");
    }
*/    
    CFRelease(pixelData);
    
    return out;
}

@end
