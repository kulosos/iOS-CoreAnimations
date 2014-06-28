//
//  btnlbl_ViewController.m
//  button_label
//
//  Created by Stefan Schmeisser on 03.01.14.
//  Copyright (c) 2014 Stefan Schmeisser. All rights reserved.
//

#import "FlipViewController.h"
#import "FlippingView.h"

@interface FlipViewController ()
@property (strong, nonatomic) IBOutlet FlippingView *flippingView;
@end

@implementation FlipViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)load:(id)sender{
    
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = (id)self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.flippingView setFrontImage:pickedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
