//
//  CAViewController.m
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 01.12.13.
//  Copyright (c) 2013 Oliver Kulas. All rights reserved.
//

#import "MainViewController.h"
#import "NavigationController.h"
#import "TestViewController.h"
#import "CustomSegue.h"
#import "CustomUnwindSegue.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSMutableArray *items; // UIViews
@property (strong, nonatomic) NSMutableArray *itemLabels; // UIView Images
@property (strong, nonatomic) NSMutableArray *itemLabelImages; // Stores the Images for itemLabels
@property (strong, nonatomic) NSMutableArray *itemLabelGradients; // Gradient Layers
@property (strong, nonatomic) NSMutableArray *itemLabelTextObjects; // Text Layer Objects in UIView
@property (strong, nonatomic) NSMutableArray *itemLabelTexts; // Stores the Texts for TextObjects
@property (nonatomic) int orientCount;
@property (strong, nonatomic) NSString * test;
@property (nonatomic, retain) CAGradientLayer *gradient;
@end

static const int ITEM_SPACE = 10;
typedef enum { PORTRAIT, LANDSCAPE } deviceOrientation;
typedef enum { COLOR_1, COLOR_2 } bgGradientColor;


@implementation MainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Create UI Elements
    [self createUI];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"-#-#-#-#-#- RUNNING OUT OF MEMORY! -#-#-#-#-#-#-");
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewWillDisappear:(BOOL)animated {
    
    // when segue did performed and the new view was loaded, self is no longer true
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
    }
    [super viewWillDisappear:animated];
}

- (void)createUI{
    
    // allocate arrays
    [self allocate];
    
    [self createBgGradient];
    
    // Create UIView Matrix (MainMenu)
    for(int i = 0; i <= 8; i++){
        
        // Create UIViews
        UIView *uiView1 = [[UIView alloc] initWithFrame: CGRectMake (110,110,110,110)];
        //uiView1.backgroundColor = [self randomColor];
        uiView1.alpha = 1.0;
        uiView1.layer.borderWidth = 1.0;
        
        // Get a randomColor and then get an appropriate second color for gradient
        UIColor * firstColor = [self randomColor];
        UIColor * secondColor = [self getAppropriateColor:firstColor];
        // Get colored and appropriate border color for uiView
        uiView1.layer.borderColor = [self getAppropriateColor:secondColor].CGColor;
        
        //add UIView to MainView
        [self.view addSubview:uiView1];
        
        // Create Color Gradient for UIView
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = uiView1.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)firstColor.CGColor,
                           (id)secondColor.CGColor,
                           nil];
        gradient.locations = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.0f],
                             [NSNumber numberWithFloat:0.8f],
                             nil];
        // set start and end points for vertical gradient
        gradient.startPoint = CGPointMake(0.0, 0.5);
        gradient.endPoint = CGPointMake(1.0, 0.5);
        // add gradient to UIView
        [uiView1.layer addSublayer:gradient];
        // add gradient to array
        [self.itemLabelGradients addObject:gradient];
        
        
        // Create ImageLabel for UIView
        CALayer *label = [CALayer layer];
        label.frame = CGRectMake(uiView1.frame.origin.x-(uiView1.bounds.size.width),
                                 uiView1.frame.origin.y-(uiView1.bounds.size.height),
                                 uiView1.frame.size.width,
                                 uiView1.frame.size.height);
        
        label.cornerRadius = 2.0;
        UIImage *img =  [self.itemLabelImages objectAtIndex:i];
        label.contents = (id)img.CGImage;
        //label.backgroundColor = [UIColor redColor].CGColor;
        label.borderWidth = 0;
        label.masksToBounds = YES;
        
        [uiView1.layer addSublayer:label];
        //add CALayer Label to array
        [self.itemLabels addObject:label];
        
        
        // Create TextLabel for UIView
        CGRect textLabelRect = CGRectMake(0 + 30,
                                          0 + uiView1.frame.origin.y-30 ,
                                          uiView1.frame.size.width,
                                          50);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:textLabelRect];
        textLabel.numberOfLines = 1;
        textLabel.textColor = [UIColor whiteColor];
        //label.backgroundColor = [UIColor blackColor].CGColor;
        //textLabel.alpha = 1.0;
        NSString *labelText = [self.itemLabelTexts objectAtIndex:i];
        textLabel.text = labelText;
        [uiView1 addSubview:textLabel];
        
        // add UILabel to array
        [self.itemLabelTextObjects addObject:textLabel];
        
        // add UIView to array
        [self.items addObject:uiView1];
        
        // add UITapGestureRecognizer for UIView
        [self addGestureHandle:uiView1:i];
    }
    
    // init Listener for DeviceOrientation detection (controls the uiTargetPositions)
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectOrientation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)detectOrientation{
    
    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) ||
        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
        self.orientCount++;
        //NSLog(@"device rotation landscape (%d times orientation changed)", self.orientCount);
        [self animateUItoTargetPosition:LANDSCAPE];
    }
    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait ||
             [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        self.orientCount++;
        //NSLog(@"device rotation portrait (%d times orientation changed)", self.orientCount);
        [self animateUItoTargetPosition:PORTRAIT];
    }
}

- (void)animateUItoTargetPosition:(deviceOrientation)deviceOrientation{
    
    //[self getScreenSize:YES]; // print ScreenSize in console
    
    if(deviceOrientation == PORTRAIT){
        
        //NSLog(@"animate UI for device orientation: PORTRAIT");
        
        int itemsInRow = 3;
        
        //CGSize itemSize = CGSizeMake(round(([self getScreenSize:NO].width / itemsInRow)), round(([self getScreenSize:NO].height / itemsInRow)));
        //NSLog(@"Portrait - itemWidth: %f and itemHeight: %f", itemSize.width, itemSize.height);
        
        int edgeLength = round((([self getScreenSize:NO].width - 10) / itemsInRow));
        //NSLog(@"Portrait - EdgeLength: %d", edgeLength);
        
        for(int i = 0; i < self.items.count; i++){
            
        __weak UIView *currentView = [self.items objectAtIndex:i];
        __weak UILabel *currentLabel = [self.itemLabels objectAtIndex:i];
        __weak CAGradientLayer *currentGradient = [self.itemLabelGradients objectAtIndex:i];
        __weak UILabel *currentTextLabel = [self.itemLabelTextObjects objectAtIndex:i];
            
        float smallerScaleValue = edgeLength * 0.02;
        
        // CoreAnimation TimeIntervall
        NSTimeInterval ti = 1.0;
        NSTimeInterval delay = 0.0;
        [UIView animateWithDuration:ti
                              delay:delay
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                             
                             // animation end values
                             
                             if(i <= 2){
                                 currentView.frame = CGRectMake(6 + edgeLength * i, 70, edgeLength - smallerScaleValue, edgeLength - smallerScaleValue);
                             }
                             
                             if(i <= 5 && i > 2){
                                 currentView.frame = CGRectMake(6 + edgeLength * (i-3), 70 + edgeLength, edgeLength - smallerScaleValue, edgeLength - smallerScaleValue);
                             }
                             
                             if(i <= 8 && i > 5){
                                 currentView.frame = CGRectMake(6 + edgeLength * (i-6), 70 + edgeLength*2, edgeLength - smallerScaleValue, edgeLength - smallerScaleValue);
                             }
                             
                             //currentView.alpha = 1.0;
                             //currentView.backgroundColor = [UIColor greenColor];
                             
                             // Scale Label in UIView smaller
                             currentLabel.frame = CGRectMake(0 + smallerScaleValue / 2,
                                                             0 + smallerScaleValue / 2,
                                                             edgeLength - smallerScaleValue*2,
                                                             edgeLength - smallerScaleValue*2);
                             
                             // Set position for TextLabel on UIViews
                             currentTextLabel.textAlignment = NSTextAlignmentLeft;
                             
                             currentTextLabel.frame = CGRectMake(currentView.bounds.size.width*0.1,
                                                                 currentView.bounds.size.height-(currentView.bounds.size.height*0.2),
                                                                 edgeLength,
                                                                 20);
                             if(edgeLength < 250){
                                 currentTextLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:13];
                             }
                             else{
                                 currentTextLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:16];
                             }
                             
                             // Scale gradient layers to UIViews bound size
                             currentGradient.frame = currentView.bounds;
                             
                             // Scale background gradient to mainViews bound size
                             self.gradient.frame = self.view.bounds;
                             
                             //currentLabel.transform = CGAffineTransformScale(currentLabel.transform, 0.75, 0.8);
                             
                             //Scale item with center pivot
                             //currentView.transform = CGAffineTransformScale(currentView.transform, 0.99, 0.99);
                             
                         }
                         completion:^(BOOL finished){

                         }];
        }
    }
    
    if(deviceOrientation == LANDSCAPE){
       
        //NSLog(@"animate UI for device orientation: LANDSCAPE");
        
        int itemsInRow = 4;
        
        //CGSize itemSize = CGSizeMake(round(([self getScreenSize:NO].width / itemsInRow)), 100);
        //NSLog(@"Landscape - itemWidth: %f and itemHeight: %f", itemSize.width, itemSize.height);
        
        int edgeLength = round([self getScreenSize:NO].height / itemsInRow);
        int itemHeight = round(([self getScreenSize:NO].width - 56) / 9);
        //NSLog(@"Landscape - EdgeLength: %d", edgeLength);
        
        
        for(int i = 0; i < self.items.count; i++){
            
            __weak UIView *currentView = [self.items objectAtIndex:i];
            __weak UILabel *currentLabel = [self.itemLabels objectAtIndex:i];
            __weak CAGradientLayer *currentGradient = [self.itemLabelGradients objectAtIndex:i];
            __weak UILabel *currentTextLabel = [self.itemLabelTextObjects objectAtIndex:i];
            
            //float smallerScaleValue = edgeLength * 0.05;
            
            // CoreAnimation TimeIntervall
            NSTimeInterval ti = 1.0;
            NSTimeInterval delay = 0.0;
            [UIView animateWithDuration:ti
                                  delay:delay
                                options:UIViewAnimationOptionTransitionFlipFromBottom
                             animations:^{
                                 
                                 // animation end values
                                 
                                 currentView.frame = CGRectMake(0, 56 + itemHeight * i, edgeLength, itemHeight-1);
                                 //currentView.alpha = 0.5;
                                 currentView.backgroundColor = [self randomColor];
                                 
                                 //Scale item with center pivot
                                 //currentView.transform = CGAffineTransformScale(currentView.transform, 1, 0.95);
                                 
                                 // Scale Label in UIView smaller
                                 currentLabel.frame = CGRectMake(0, 0 , itemHeight, itemHeight);
                                 
                                 // Set position for TextLabel on UIViews
                                 currentTextLabel.textAlignment = NSTextAlignmentRight;
                                 currentTextLabel.frame = CGRectMake(0,
                                                                     0,
                                                                     edgeLength - (currentView.bounds.size.width*0.05),
                                                                     itemHeight);
                                 if(edgeLength < 250){
                                     currentTextLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:12];
                                 }
                                 else{
                                     currentTextLabel.font = [UIFont fontWithName:@"Avenir Next Ultra Light" size:16];
                                 }
                                 
                                 
                                 // Scale gradient layers to UIViews bound size
                                 currentGradient.frame = currentView.bounds;
                                 
                                 // Scale background gradient to mainViews bound size
                                 self.gradient.frame = self.view.bounds;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}

- (void)setLabelTexts{
    
    self.itemLabelTexts = [[NSMutableArray alloc] init];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Standard"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Custom Segue"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Filters"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"GreenScreen"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Flipping"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"FlipGallery"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Particles"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Physics"]];
    [self.itemLabelTexts addObject:[NSMutableString stringWithFormat:@"Settings"]];
}

- (void)setLabelImages{
    
    self.itemLabelImages = [[NSMutableArray alloc] init];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_gallery.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_gallery2.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_filters2.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_stripes.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_flip.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_flipGallery.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_particles.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_physics.png"]];
    [self.itemLabelImages addObject:[UIImage imageNamed:@"menu_settings.png"]];
}

- (UIColor *)randomColor{
    
    switch (arc4random()%8) {
        case 0: return [UIColor colorWithRed:( 81/255.0) green:( 51/255.0) blue:(171/255.0) alpha:(255/255)]; // purple
        case 1: return [UIColor colorWithRed:( 38/255.0) green:(116/255.0) blue:(206/255.0) alpha:(255/255)]; // light blue
        case 2: return [UIColor colorWithRed:(  0/255.0) green:(138/255.0) blue:( 80/255.0) alpha:(255/255)]; // green
        case 3: return [UIColor colorWithRed:(  9/255.0) green:( 74/255.0) blue:(178/255.0) alpha:(255/255)]; // blue
        case 4: return [UIColor colorWithRed:(210/255.0) green:( 71/255.0) blue:( 38/255.0) alpha:(255/255)]; // organe
        case 5: return [UIColor colorWithRed:(  0/255.0) green:(136/255.0) blue:(178/255.0) alpha:(255/255)]; // aqua
        case 6: return [UIColor colorWithRed:(172/255.0) green:( 25/255.0) blue:( 61/255.0) alpha:(255/255)]; // wine red
        case 7: return [UIColor colorWithRed:(141/255.0) green:(  0/255.0) blue:(150/255.0) alpha:(255/255)]; // light purple
    }
    return [UIColor blackColor];
}

- (UIColor *)getAppropriateColor:(UIColor *)color{
    
    CGFloat hue, sat, lum, alpha = 0;
    [color getHue: &hue saturation: &sat brightness: &lum alpha: &alpha];
    //NSLog(@"Hue = %f. Saturation = %f. Luminance = %f. Alpha = %f", hue, sat, lum, alpha);
    
    return [[UIColor alloc] initWithHue:hue saturation:sat-0.1 brightness:lum+0.25 alpha:alpha];
}

- (UIColor *)bgColor:(bgGradientColor)color{
    
    if(color == COLOR_1){
        return [UIColor colorWithRed:(0/255.0) green:(64/255.0) blue:(80/255.0) alpha:(255/255)]; // petrol
    }
    
    else{
        return [UIColor colorWithRed:(0/255.0) green:(113/255.0) blue:(117/255.0) alpha:(255/255)]; // petrol dark
    }
}

- (void)createBgGradient{
    
    // Create Color Gradient for mainView
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:
                            (id)[self bgColor:COLOR_1].CGColor,
                            (id)[self bgColor:COLOR_2].CGColor,
                            nil];
    self.gradient.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:0.7f],
                               nil];
    // set start and end points for diagonal gradient
    self.gradient.startPoint = CGPointMake(0.0, 0.5);
    self.gradient.endPoint = CGPointMake(1.0, 0.0);
    
    // lay in background
    [self.gradient.sublayers lastObject];
    
    // add gradient to UIView
    [self.view.layer addSublayer:self.gradient];
    
    // animate bgGradient
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                    target:self
                                   selector:@selector(animateBgGradient)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)animateBgGradient{
    
    NSTimeInterval ti = 10.0;
    NSTimeInterval delay = 0.0;
    
    [UIView animateWithDuration:ti
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [CATransaction begin];
                         [CATransaction setAnimationDuration:ti];
                         
                         // Get a randomColor and then get an appropriate second color for gradient
                         UIColor * firstColor = [self randomColor];
                         UIColor * secondColor = [self getAppropriateColor:firstColor];
                         
                         self.gradient.colors = [NSArray arrayWithObjects:
                                                 (id)firstColor.CGColor,
                                                 (id)secondColor.CGColor,
                                                 nil];
                         [CATransaction commit];
                     }
                     completion:^(BOOL b) {
                         
                     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *segueString = @"tranfered example text string from mainViewController";
    
    //MainViewController * currentView = (id)sender;
    //NSLog(@"menu1 - x: %f y: %f", currentView.view.center.x, currentView.view.center.y);
    
    if ([segue.identifier isEqualToString:@"showPhotoView"]) {
        TestViewController *destViewController = segue.destinationViewController;
        destViewController.photoViewName = segueString;
    }
    else if ([segue.identifier isEqualToString:@"showViewAnders"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showViewGanzAnders"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showParticleView"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showPhotoPickerView"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showFlippingView"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showPhysicsView"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showGalleryView"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    else if ([segue.identifier isEqualToString:@"showSettings"]) {
        ((CustomSegue *)segue).originatingPoint = self.segueScalePoint;
    }
    
}

- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
    // Nothing to do here
    
    // This is the IBAction method referenced in the Storyboard Exit for the Unwind segue.
    // It needs to be here to create a link for the unwind segue.
}

- (void)addGestureHandle:(UIView *)currentView : (int)menu {
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    currentView.tag = menu; // tag is the unique identifier
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [currentView addGestureRecognizer:singleTap];
}

- (void)handleGesture:(UIGestureRecognizer *)sender {
    
    // set center scaling point from appropriate sending menu element (UIView)
    self.segueScalePoint = CGPointMake(sender.view.center.x, sender.view.center.y);
    
    //nc.segueScalePoint = self.segueScalePoint;
    //[nc setSegueScalePoint:(CGPointMake(150,150))];
    
    switch (sender.view.tag) {
        case 0:
        {
            //NSLog(@"menu1 - x: %f y: %f", self.segueScalePoint.x, self.segueScalePoint.y);
            //NSLog(@"menu1");
            [self performSegueWithIdentifier:@"showPhotoView" sender:self];
            break;
        }
        case 1:
        {
            //NSLog(@"menu2");
            [self performSegueWithIdentifier:@"showViewAnders" sender:self];
            break;
        }
        case 2:
        {
            //NSLog(@"menu3 - photoPicker");
            [self performSegueWithIdentifier:@"showPhotoPickerView" sender:self];
            break;
        }
        case 3:
        {
            //NSLog(@"menu4");
            [self performSegueWithIdentifier:@"showViewGanzAnders" sender:self];
            break;
        }
        case 4:
        {
            //NSLog(@"menu5 - particles");
            [self performSegueWithIdentifier:@"showFlippingView" sender:self];
            break;
        }
        case 5:
        {
            //NSLog(@"menu6 - flippingView");
            [self performSegueWithIdentifier:@"showGalleryView" sender:self];
            break;
        }
        case 6:
        {
            //NSLog(@"menu7 - physicsView");
            [self performSegueWithIdentifier:@"showParticleView" sender:self];
            
            break;
        }
        case 7:
        {
            //NSLog(@"menu8");
            [self performSegueWithIdentifier:@"showPhysicsView" sender:self];
            break;
        }
        case 8:
        {
            //NSLog(@"menu9");
            [self performSegueWithIdentifier:@"showSettings" sender:self];
            break;
        }
        default:
        {
            // set default scaling point to screen center
            self.segueScalePoint = self.view.center;
        }
     }
}

- (CGSize)getScreenSize:(BOOL)printScreenSize{
    
    //Get Size of the Screen, from the object that represents the screen itself
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize size = CGSizeMake(screenRect.size.width, screenRect.size.height);
    
    if(printScreenSize){
        NSLog(@"ScreenWidth: %f - ScreenHeight: %f", size.width, size.height);
    }
    return size;
}

- (void)allocate{
    
    // allocate Arrays
    self.items = [[NSMutableArray alloc] init];
    self.itemLabels = [[NSMutableArray alloc] init];
    self.itemLabelImages = [[NSMutableArray alloc] init];
    self.itemLabelGradients = [[NSMutableArray alloc] init];
    self.itemLabelTexts = [[NSMutableArray alloc] init];
    self.itemLabelTextObjects = [[NSMutableArray alloc] init];
    
    [self setLabelTexts];
    [self setLabelImages];
}

@end
