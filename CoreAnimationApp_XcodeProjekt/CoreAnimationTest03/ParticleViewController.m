//
//  ParticleViewController.m
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 04.01.14.
//  Copyright (c) 2014 Oliver Kulas. All rights reserved.
//

#import "ParticleViewController.h"

@interface ParticleViewController ()

@property (nonatomic, weak) CAEmitterLayer *emitter;
@property (nonatomic, strong) NSString *imageName;

@property (strong, nonatomic) IBOutlet UISlider *sliderRate;
@property (strong, nonatomic) IBOutlet UILabel *labelRate;
@property (strong, nonatomic) IBOutlet UISlider *sliderLifetime;
@property (strong, nonatomic) IBOutlet UILabel *labelLifetime;
@property (strong, nonatomic) IBOutlet UISlider *sliderLifetimeRange;
@property (strong, nonatomic) IBOutlet UILabel *labelLifetimeRange;
@property (strong, nonatomic) IBOutlet UISlider *sliderVelocity;
@property (strong, nonatomic) IBOutlet UILabel *labelVelocity;
@property (strong, nonatomic) IBOutlet UISlider *sliderVeloctiyRange;
@property (strong, nonatomic) IBOutlet UILabel *labelVelocityRange;
@property (strong, nonatomic) IBOutlet UISlider *sliderXAcceleration;
@property (strong, nonatomic) IBOutlet UILabel *labelXAcceleration;
@property (strong, nonatomic) IBOutlet UISlider *sliderAcceleration;
@property (strong, nonatomic) IBOutlet UILabel *labelAcceleration;
@property (strong, nonatomic) IBOutlet UISlider *sliderEmissionLongitude;
@property (strong, nonatomic) IBOutlet UILabel *labelEmissionLongitude;
@property (strong, nonatomic) IBOutlet UISlider *sliderEmissionRange;
@property (strong, nonatomic) IBOutlet UILabel *labelEmissionRange;
@property (strong, nonatomic) IBOutlet UISlider *sliderScale;
@property (strong, nonatomic) IBOutlet UILabel *labelScale;
@property (strong, nonatomic) IBOutlet UISlider *sliderScaleSpeed;
@property (strong, nonatomic) IBOutlet UILabel *labelScaleSpeed;
@property (strong, nonatomic) IBOutlet UISlider *sliderScaleRange;
@property (strong, nonatomic) IBOutlet UILabel *labelScaleRange;

@property (strong, nonatomic) IBOutlet UIButton *buttonChangeParticle;
@property int particleId;
@end

@implementation ParticleViewController

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
    
    [self setParticleId:1];
    
    // init particle system
    [self createParticles:self.particleId];
    
    // Init GestureRecognizer
    [self initGestures];
}

- (void)createParticles:(int)particleId{
    
    CALayer *particleLayer = [self.view layer];
    NSUInteger smokeNumber = particleId;
    NSString *imageName = [NSString stringWithFormat:@"particle%lu", (unsigned long)smokeNumber];
    [self setImageName:imageName];
    UIImage *image = [UIImage imageNamed:imageName];
    assert(image);
    
    // Setting up the CAEmitterCell
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    [cell setName:imageName];
    float defaultBirthRate = 2.0f;
    [cell setBirthRate:defaultBirthRate];
    [cell setVelocity:120];
    [cell setVelocityRange:40];
    [cell setXAcceleration:-45.0f];
    [cell setYAcceleration:-45.0f];
    [cell setEmissionLongitude:-M_PI_2];
    [cell setEmissionRange:M_PI_4];
    [cell setScale:1.0f];
    [cell setScaleSpeed:2.0f];
    [cell setScaleRange:2.0f];
    [cell setContents:(id)image.CGImage];
    [cell setColor:[UIColor colorWithRed:1.0
                                   green:0.2
                                    blue:0.1
                                   alpha:0.5].CGColor];
    [cell setLifetime:0.5f];
    [cell setLifetimeRange:1.0f];
    
    // set life time for iphone or ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [cell setLifetime:6.0f];
        [cell setLifetimeRange:2.0f];
    }
    else {
        [cell setLifetime:3.0f];
        [cell setLifetimeRange:1.0f];
    }
    
    // Setting up the CAEmitterLayer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    [self setEmitter:emitter];
    [emitter setEmitterCells:@[cell]];
    CGRect bounds = [self.view bounds];
    [emitter setFrame:bounds];
    CGPoint emitterPosition = (CGPoint) {bounds.size.width*0.7f,bounds.size.height*0.6f};
    [emitter setEmitterPosition:emitterPosition];
    [emitter setEmitterSize:(CGSize){10.0f, 10.0f}];
    [emitter setEmitterShape:kCAEmitterLayerRectangle];
    [emitter setRenderMode:kCAEmitterLayerAdditive];
    [particleLayer addSublayer:emitter];
    [self setEmitter:emitter];
    
    // Setting up birthRate
    float birthRateMin = 1.0f;
    float birthRateMax = 50.0f;
    [self.sliderRate setMinimumValue:birthRateMin];
    [self.sliderRate setMaximumValue:birthRateMax];
    [self.sliderRate setValue:defaultBirthRate animated:NO];
    //[self.labelRate setText:[NSString stringWithFormat:@"%4.2f", defaultBirthRate]];
    
    // set layer order
    particleLayer.zPosition = -1;
    emitter.zPosition = -1;
}

- (void)initGestures{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:singleTap];
}

- (void)doubleTap:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.view];
    NSString *animationKey = @"position";
    CGFloat duration = 1.0f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"emitterPosition"];
    //CAEmitterLayer *presentation = (CAEmitterLayer*)[self.emitter presentationLayer];
    CGPoint currentPosition = self.view.center;
    
    [animation setFromValue:
     [NSValue valueWithCGPoint:currentPosition]];
    [animation setToValue:[NSValue valueWithCGPoint:location]];
    [animation setDuration:duration];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    [self.emitter addAnimation:animation forKey:animationKey];
}

- (IBAction)sliderRateChanged:(id)sender {
    //NSLog(@"%@ %@", NSStringFromSelector(_cmd), sender);
    float value = [(UISlider *)sender value];
    [self.labelRate setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.birthRate", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderLifetimeChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelLifetime setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.lifetime", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderLifetimeRangeChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelLifetimeRange setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.lifetimeRange", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderVelocityChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelVelocity setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.velocity", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderVelocityRangeChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelVelocityRange setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.velocityRange", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderXAcceralerationChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelXAcceleration setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.xAcceleration", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderAccerlerationChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelAcceleration setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.yAcceleration", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderEmissionLongitudeChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelEmissionLongitude setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.emissionLongitude", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderEmissionRangeChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelEmissionRange setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.emissionRange", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderScaleChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelScale setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.scale", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderScaleSpeedChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelScaleSpeed setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.scaleSpeed", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)sliderScaleRangeChanged:(id)sender{
    float value = [(UISlider *)sender value];
    [self.labelScaleRange setText:[NSString stringWithFormat:@"%4.2f", value]];
    NSString *keyPath = [NSString stringWithFormat:@"emitterCells.%@.scaleRange", self.imageName];
    [self.emitter setValue:@(value) forKeyPath:keyPath];
}

- (IBAction)buttonChangeParticle:(id)sender {
    
    if(self.particleId == 1){
        [self.emitter removeFromSuperlayer];
        [self createParticles:1];
        [self setParticleId:2];
    }
    
    else if(self.particleId == 2){
        [self.emitter removeFromSuperlayer];
        [self createParticles:2];
        [self setParticleId:1];
    }
}


@end
