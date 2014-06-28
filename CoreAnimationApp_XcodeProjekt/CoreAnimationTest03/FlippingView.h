//
//  FlippingView.h
//  button_label
//
//  Created by Steffen on 05.01.14.
//  Copyright (c) 2014 Stefan Schmeisser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistogramView.h"

@interface FlippingView : UIView
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andFrontimage:(UIImage*) image;
- (void) setFrontImage:(UIImage *)frontImage;
@property (strong, nonatomic) IBOutlet UIImageView* frontView;      // image
@property (strong, nonatomic) IBOutlet HistogramView* backView;     // image + histogram
@end
