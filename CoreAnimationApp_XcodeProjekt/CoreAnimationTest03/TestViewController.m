//
//  PhotoView.m
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 25.12.13.
//  Copyright (c) 2013 Oliver Kulas. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@end

@implementation TestViewController

@synthesize photoViewName, photoViewNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    photoViewNameLabel.text = photoViewName;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMainView:(id)sender {
    //NSLog(@"back button");
}
/*
- (void)didMoveToParentViewController:(UIViewController *)parent{
    // Event: BackButton was pressed
    if (![parent isEqual:self.parentViewController]) {
        NSLog(@"---------------> Back pressed");
    }
}*/

@end
