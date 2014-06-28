//
//  PhotoPickerViewController.m
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 05.01.14.
//  Copyright (c) 2014 Oliver Kulas. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoPickerViewController ()
@property float sliderValueSephia;
@end

@implementation PhotoPickerViewController {
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
}
@synthesize amountSlider;
@synthesize imgV;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
    //[self logAllFilters];
}

- (void)viewDidUnload{
    [self setImgV:nil];
    [self setAmountSlider:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}

- (void)initView{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TBIY" ofType:@"jpg"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    
    beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];
    
    filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    [imgV setImage:newImg];
    
    CGImageRelease(cgimg);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)changeValue:(UISlider *)sender {
    
    [self setSliderValueSephia:[sender value]];
}

-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    beginImage = [CIImage imageWithCGImage:gotImage.CGImage];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [self changeValue:amountSlider];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePhoto:(id)sender {
    
    CIImage *saveToSave = [filter outputImage];
    CGImageRef cgImg = [context createCGImage:saveToSave fromRect:[saveToSave extent]];
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    // save path
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AJFW" ofType:@"jpg"];
    //NSURL * savePath = [NSURL fileURLWithPath:filePath];
    
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[saveToSave properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              CGImageRelease(cgImg);
                              NSLog(@"Image saved");
                          } ];
}

- (IBAction)applyButton:(id)sender{
    
    [filter setValue:[NSNumber numberWithFloat:[self sliderValueSephia]] forKey:@"inputIntensity"];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    [imgV setImage:newImg];
    
    CGImageRelease(cgimg);
}

@end
