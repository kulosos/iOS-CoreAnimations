//
//  NavigationController.m
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 28.12.13.
//  Copyright (c) 2013 Oliver Kulas. All rights reserved.
//

#import "NavigationController.h"
#import "MainViewController.h"
#import "CustomSegue.h"
#import "CustomUnwindSegue.h"

@interface NavigationController ()

@end

@implementation NavigationController

@synthesize segueScalePoint;

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
	// Do any additional setup after loading the view.
    
    [self getScreenSize:YES];
    
    // temporarly set center for unwind segueScale
    [self setSegueScalePoint:(CGPointMake(self.view.center.x, self.view.center.y))];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGSize)getScreenSize:(BOOL)printScreenSize{
    
    //Get Size of the Screen, from the object that represents the screen itself
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    if(printScreenSize){
        NSLog(@"NavController ScreenWidth: %f - ScreenHeight: %f", size.width, size.height);
    }
    return size;
}

//override this method from UIViewController to provide a custom segue for unwinding
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier {
    // Instantiate a new CustomUnwindSegue
    CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    
    // Set the target point for the animation to the center of the button in this VC
    segue.targetPoint = self.segueScalePoint;
    
    //NSLog(@"SEGUEPOINT from MAINVIEW - x: %f y: %f", self.segueScalePoint.x, self.segueScalePoint.y);
    return segue;
}

@end
