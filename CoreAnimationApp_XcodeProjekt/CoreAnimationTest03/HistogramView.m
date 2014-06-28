//
//  HistogramView.m
//  TestApp
//
//  Created by Steffen on 30.12.13.
//  Copyright (c) 2013 Steffen. All rights reserved.
//

#import "HistogramView.h"
#import <math.h>

#define kDuration 2.5f
#define kBorder 15

@interface HistogramView()
@property (strong, nonatomic)  CAShapeLayer* layerBackground;
@property (strong, nonatomic)  CAShapeLayer* layerX;
@property (strong, nonatomic)  CAShapeLayer* layerY;
@property (strong, nonatomic)  CAShapeLayer* layerGraph;
@end

@implementation HistogramView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // ...
    }
    return self;
}

- (void) initLayer{
    
    CGRect paperRect = self.bounds;
    
    // background
    if (!self.layerBackground){

        self.layerBackground = [CAShapeLayer layer];
        self.layerY.fillColor = [[UIColor blackColor] CGColor];
        self.layerBackground.opacity = 0.6f;
        
        UIBezierPath* pathBG = [UIBezierPath bezierPath];
        [pathBG moveToPoint:CGPointMake(0, 0)];
        [pathBG addLineToPoint:CGPointMake(paperRect.size.width, 0)];
        [pathBG addLineToPoint:CGPointMake(paperRect.size.width, paperRect.size.height)];
        [pathBG addLineToPoint:CGPointMake(0, paperRect.size.height)];
        [pathBG addLineToPoint:CGPointMake(0, 0)];
        self.layerBackground.path = pathBG.CGPath;
        
        [self.layer addSublayer:self.layerBackground];
    }
    
    // x axis
    if (!self.layerX){
        self.layerX = [CAShapeLayer layer];
        self.layerX.strokeColor = [[UIColor whiteColor] CGColor];
        self.layerX.fillColor = nil;
        self.layerX.lineWidth = 1.f;
        
        // draw x axis
        UIBezierPath* pathX = [UIBezierPath bezierPath];
        [pathX moveToPoint:CGPointMake(kBorder/4, paperRect.size.height - kBorder/2)];
        [pathX addLineToPoint:CGPointMake(paperRect.size.width - kBorder/4, paperRect.size.height - kBorder/2)];
        self.layerX.path = pathX.CGPath;
        
        [self.layer addSublayer:self.layerX];
    }
    
    // y axis
    if (!self.layerY){
        self.layerY = [CAShapeLayer layer];
        self.layerY.strokeColor = [[UIColor whiteColor] CGColor];
        self.layerY.fillColor = nil;
        self.layerY.lineWidth = 1.f;
        
        // draw y axis
        UIBezierPath* pathY = [UIBezierPath bezierPath];
        [pathY moveToPoint:CGPointMake(kBorder/2, paperRect.size.height - kBorder/4)];
        [pathY addLineToPoint:CGPointMake(kBorder/2, kBorder/4)];
        self.layerY.path = pathY.CGPath;
        
        [self.layer addSublayer:self.layerY];
    }

    // graph
    if (!self.layerGraph){
        self.layerGraph = [CAShapeLayer layer];
        self.layerGraph.strokeColor = [UIColor whiteColor].CGColor;
        self.layerGraph.fillColor = nil;
        self.layerGraph.lineWidth = 1.f;
        
        if(self.histogram != nil){
            
            int maxValue = 0, currentValue = 0, x = 0, y = 0;
            
            // get maxValue;
            for(int i = 0; i < [self.histogram count]; i++){
                currentValue = [[self.histogram objectAtIndex:i] integerValue];
                if(currentValue > maxValue) maxValue = currentValue;
            }
            
            //beginning
            UIBezierPath* path0 = [UIBezierPath bezierPath];
            [path0 moveToPoint:CGPointMake(kBorder, paperRect.size.height - kBorder)];
            
            for(int i = 0; i < [self.histogram count]; i++){
                x = kBorder + round(((float) i / (float) [self.histogram count]) * (paperRect.size.width - kBorder*2));
                y = round((paperRect.size.height) - ((float) [[self.histogram objectAtIndex:i] integerValue] / (float) maxValue) * (paperRect.size.height - 2*kBorder)) - kBorder;
                [path0 addLineToPoint:CGPointMake(x,y)];
            }
            
            // end
            
            self.layerGraph.path = path0.CGPath;
        }
            
        [self.layer addSublayer:self.layerGraph];
    }
}

- (void) animate{
    
    [self initLayer];
    
    CABasicAnimation* animationX = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animationX.duration = kDuration;
    animationX.fromValue = [NSNumber numberWithFloat:0.0f];
    animationX.toValue = [NSNumber numberWithFloat:1.0f];
    animationX.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    [self.layerX addAnimation:animationX forKey:@"strokeEnd"];
    
    CABasicAnimation* animationY = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animationY.duration = kDuration;
    animationY.fromValue = [NSNumber numberWithFloat:0.0f];
    animationY.toValue = [NSNumber numberWithFloat:1.0f];
    animationY.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    [self.layerY addAnimation:animationY forKey:@"strokeEnd"];

    if(self.histogram != nil){
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = kDuration;
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];
        animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        [self.layerGraph addAnimation:animation forKey:@"strokeEnd"];
    }else{
        NSLog(@"no histogram data");
    }
}


- (void) reset{
    [self.layerBackground removeFromSuperlayer];
    [self.layerX removeFromSuperlayer];
    [self.layerY removeFromSuperlayer];
    [self.layerGraph removeFromSuperlayer];
    
    self.layerBackground = nil;
    self.layerX = nil;
    self.layerY = nil;
    self.layerGraph = nil;
}

-(void)setHistogram:(NSMutableArray *)histogram{
    _histogram = histogram;
}
@end
