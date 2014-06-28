//
//  GalleryViewController.m
//  CoreAnimation
//
//  Created by Oliver Kulas on 13.01.14.
//  Copyright (c) 2014 Oliver Kulas. All rights reserved.
//

#import "GalleryViewController.h"
#import "FlippingView.h"

@interface GalleryViewController ()
@property (strong, nonatomic) IBOutletCollection(FlippingView) NSArray *flippingViews;

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[self.flippingViews objectAtIndex:0] setFrontImage:[UIImage imageNamed:@"IMG_01.jpg"]];
    [[self.flippingViews objectAtIndex:1] setFrontImage:[UIImage imageNamed:@"IMG_02.JPG"]];
    [[self.flippingViews objectAtIndex:2] setFrontImage:[UIImage imageNamed:@"IMG_03.JPG"]];
    [[self.flippingViews objectAtIndex:3] setFrontImage:[UIImage imageNamed:@"IMG_04.jpg"]];
    [[self.flippingViews objectAtIndex:4] setFrontImage:[UIImage imageNamed:@"IMG_05.JPG"]];
    [[self.flippingViews objectAtIndex:5] setFrontImage:[UIImage imageNamed:@"TBIY.jpg"]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
