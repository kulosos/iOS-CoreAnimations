//
//  HistogramUtil.h
//  TestApp
//
//  Created by Steffen on 21.12.13.
//  Copyright (c) 2013 Steffen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistogramUtil : NSObject
+ (unsigned int) calculateIncValueForImage: (UIImage*) image;
+ (NSMutableArray*) calculateIntensityHistogramOfImage: (UIImage*) image andLowpass: (int) size;
+ (NSMutableArray*) calculateIntensityHistogramOfImage: (UIImage*) image withInc: (int) inc andLowpass: (int) size;
@end
