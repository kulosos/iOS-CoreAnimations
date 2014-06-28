//
//  HistorgamView.h
//  TestApp
//
//  Created by Steffen on 30.12.13.
//  Copyright (c) 2013 Steffen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView
@property (strong, nonatomic) NSMutableArray* histogram;
- (void) initLayer;
- (void) animate;
- (void) reset;
@end
