//
//  PhotoPickerViewController.h
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 05.01.14.
//  Copyright (c) 2014 Oliver Kulas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UISlider *amountSlider;

- (IBAction)changeValue:(UISlider *)sender;

- (IBAction)loadPhoto:(id)sender;

- (IBAction)savePhoto:(id)sender;

- (IBAction)applyButton:(id)sender;

@end