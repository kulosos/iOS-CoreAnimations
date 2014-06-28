//
//  FlippingView.m
//  button_label
//
//  Created by Steffen on 05.01.14.
//  Copyright (c) 2014 Stefan Schmeisser. All rights reserved.
//

#import "FlippingView.h"
#import "HistogramUtil.h"
#import "HistogramView.h"

#define kTransitionDuration	0.4f

@interface FlippingView()

@end

@implementation FlippingView

// init storyboard
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return [self initWithFrame:[self frame]];
}

// simple init
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        // frontside
        self.frontView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.frontView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.frontView];
        
        // backside
        self.backView = [[HistogramView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        // tap gesture
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip)];
        tgr.numberOfTapsRequired = 1;
        tgr.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tgr];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andFrontimage:(UIImage*) image{
    
    self = [super initWithFrame:frame];
    
    if (self){
        // frontside
        self.frontView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.frontView.contentMode = UIViewContentModeScaleAspectFit;
        self.frontView.image = image;
        [self addSubview:self.frontView];
        
        // backside
        self.backView = [[HistogramView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.backView setHistogram: [HistogramUtil calculateIntensityHistogramOfImage:self.frontView.image andLowpass:1]];
        
        // tap gesture
        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip)];
        tgr.numberOfTapsRequired = 1;
        tgr.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tgr];
    }
    
    return self;
}

- (void) flip{
    
    if(self.frontView.image != Nil){
    
        [self.backView animate];
    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kTransitionDuration];
    
        if ([self.backView superview]){
            [self.backView removeFromSuperview];
            [self addSubview:self.frontView];
            [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        }else{
            [self addSubview:self.backView];
            [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        }
    
        [UIView commitAnimations];
    }
}

- (void) setFrontImage:(UIImage *)frontImage{
    
    self.frontView.image = frontImage;
    
    // reset to front view
    if ([self.backView superview]){
        [self.backView removeFromSuperview];
        [self addSubview:self.frontView];
    }
    
    // reset back view (histogram view)
    [self.backView reset];
    [self.backView setHistogram: [HistogramUtil calculateIntensityHistogramOfImage:frontImage andLowpass:1]];
}

@end
