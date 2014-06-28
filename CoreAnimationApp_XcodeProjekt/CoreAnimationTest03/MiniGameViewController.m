//
//  PhysicsViewController.m
//  CoreAnimationTest03
//
//  Created by Oliver Kulas on 06.01.14.
//  Copyright (c) 2014 Oliver Kulas. All rights reserved.
//

#import "MiniGameViewController.h"
#import "PhysicsBehavior.h"

@interface MiniGameViewController () <UIDynamicAnimatorDelegate>
//@property (strong, nonatomic) PhysicsBehavior *physicsBehavior;
@property (nonatomic, retain) CAGradientLayer *gradient;
@property (strong, nonatomic) UIView * defenceTower;
@property float timeIntervall;

@property (retain, nonatomic) UIDynamicAnimator * animator;
@property (retain, nonatomic) UIGravityBehavior * rocketGravity;
@property (retain, nonatomic) UIGravityBehavior * enemyGravity;
@property (strong, nonatomic) UICollisionBehavior * collision;
@property CGPoint defenceTowerPosition;
@property (nonatomic, weak) CAEmitterLayer *emitter;
@property (nonatomic, strong) NSString *imageName;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSMutableArray * allMovingObjects;
@property (strong, nonatomic) NSMutableArray * objectsToDestroyById;
@property int tagID;
@end

@implementation MiniGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (PhysicsBehavior *)physicsBehavior{
    if (!_physicsBehavior) {
        _physicsBehavior = [[PhysicsBehavior alloc] init];
        [self.animator addBehavior:_physicsBehavior];
    }
    return _physicsBehavior;
}

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}
*/
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.allMovingObjects = [[NSMutableArray alloc] init];
    self.objectsToDestroyById = [[NSMutableArray alloc] init];
    [self setTagID:0];
    
    [self initBehaviors];
	
    [self createBgGradient];
    [self createDefenceTower];
    [self createControls];
    [self createEnemy];
    
    [self setTimeIntervall:3.0];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(setShorterTimeIntervall)
                                   userInfo:nil
                                    repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:self.timeIntervall*2
                                     target:self
                                   selector:@selector(createEnemy)
                                   userInfo:nil
                                    repeats:YES];
    
    //Collision & OutOfBounds Detection
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(checkCollisionAndBoundaries)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)initBehaviors{
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // some UIView is necessarry to init Behavior
    UIView *uiv = [[UIView alloc] initWithFrame:CGRectMake(100,100,100,100)];
    [self.view addSubview:uiv];
    
    //self.enemyGravity = [[UIGravityBehavior alloc]initWithItems:@[uiv]];
    //[self.animator addBehavior:self.enemyGravity];
    
    self.rocketGravity = [[UIGravityBehavior alloc]initWithItems:@[uiv]];
    [self.rocketGravity setGravityDirection:CGVectorMake(0.0, -1.0)];
    [self.rocketGravity setMagnitude:0.9];
    [self.animator addBehavior:self.rocketGravity];
    
    self.collision = [[UICollisionBehavior alloc]initWithItems:@[uiv]];
    [self.collision setTranslatesReferenceBoundsIntoBoundary:NO];
    
    [self.animator addBehavior:self.collision];
}

- (void) createDefenceTower{
    
    // Create PlayerObject
    CGSize playerSize = CGSizeMake(45, 76);
    
    self.defenceTower = [[UIView alloc] initWithFrame:CGRectMake (self.view.center.x - playerSize.width/2,
                                                                  self.view.bounds.size.height - playerSize.height*2,
                                                                  playerSize.width,
                                                                  playerSize.height)];
    CALayer *playerObject = [CALayer layer];
    playerObject.frame = CGRectMake(0,
                                    0,
                                    playerSize.width,
                                    playerSize.height);
    
    playerObject.contents = (id)[UIImage imageNamed:@"defenceTower1.png"].CGImage;
    
    //[self.defenceTower setBackgroundColor:[UIColor redColor]];
    [self.defenceTower.layer addSublayer:playerObject];
    [self.view addSubview:self.defenceTower];
    
    //[self.physicsBehavior addItem:self.defenceTower withGravity:NO];
    //[self.collision addItem:self.defenceTower];
    //[self.allMovingObjects addObject:self.defenceTower];
    
    [self.defenceTower setTag:self.tagID];
    [self setTagID:self.tagID + 1];
    //NSLog(@"TagID: %d", self.tagID);
}

- (void) createEnemy{
    
    // Create Enemy
    CGSize enemySize = CGSizeMake(100, 100);
    
    int xValue = [self getRandomNumberBetween:0 maxNumber: self.view.bounds.size.width];
    
    UIView *enemyView = [[UIView alloc] initWithFrame:CGRectMake (xValue,
                                                                  0 - enemySize.height,
                                                                  enemySize.width,
                                                                  enemySize.height)];
    // animated ImageView
    UIImageView* animatedEnemy = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,enemySize.width,enemySize.height)];
    animatedEnemy.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"enemy1.png"],
                                         [UIImage imageNamed:@"enemy2.png"],
                                         [UIImage imageNamed:@"enemy3.png"], nil];
    animatedEnemy.animationDuration = 0.5f;
    animatedEnemy.animationRepeatCount = 0;
    [animatedEnemy startAnimating];
    
    //[enemyView setBackgroundColor:[UIColor greenColor]];
    
    [enemyView addSubview:animatedEnemy];
    [self.view addSubview:enemyView];
    
    [self.allMovingObjects addObject:enemyView];
    
    [enemyView setTag:self.tagID];
    [self setTagID:self.tagID+1];
    //NSLog(@"TagID: %d", self.tagID);
    
    [UIView animateWithDuration:15.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         enemyView.frame = CGRectMake (xValue,
                                                       self.view.bounds.size.height + enemySize.height,
                                                       enemySize.width,
                                                       enemySize.height);
                     }
                     completion:^(BOOL finished){
                         //Remove enemyView after animation from all
                         [self.collision removeItem:enemyView];
                         [enemyView removeFromSuperview];
                         [self.allMovingObjects removeObject:enemyView];
                         
                     }];
    
    [self.collision addItem:enemyView];
}

- (void) checkCollisionAndBoundaries{

    //NSLog(@"ArrayCount: %lu", (unsigned long)self.allMovingObjects.count);
    
    for(int i = 0; i < self.allMovingObjects.count; i++){
        
        UIView * aView = [self.allMovingObjects objectAtIndex:i];
        CGRect aFrame = [(CALayer*)[aView.layer presentationLayer] frame];
        
        for(int j = 0; j < self.allMovingObjects.count; j++){
            
            UIView * anotherView = [self.allMovingObjects objectAtIndex:j];
            
            if(aView!=anotherView){
                
                CGRect anotherFrame = [(CALayer*)[anotherView.layer presentationLayer] frame];
                
                if(CGRectIntersectsRect(aFrame, anotherFrame)){
                    
                    [self createExplosion:CGPointMake(aFrame.origin.x, aFrame.origin.y)];
                    
                    NSLog(@"COLLISON");
                    // destroy and remove object from views and arrays
                    [self.collision removeItem:aView];
                    [self.rocketGravity removeItem:aView];
                    [self.enemyGravity removeItem:aView];
                    [self.allMovingObjects removeObject:aView];
                    [aView removeFromSuperview];
                    
                    [self.collision removeItem:anotherView];
                    [self.rocketGravity removeItem:anotherView];
                    [self.enemyGravity removeItem:anotherView];
                    [self.allMovingObjects removeObject:anotherView];
                    [anotherView removeFromSuperview];
                }
                else if(aView.center.y < (aView.bounds.size.height * -1)){
                    NSLog(@"OUT OF TOP BOUNDS");
                    [self.collision removeItem:aView];
                    [self.rocketGravity removeItem:aView];
                    [self.enemyGravity removeItem:aView];
                    [self.allMovingObjects removeObject:aView];
                    [aView removeFromSuperview];
                }
                
                else if(anotherView.center.y < (anotherView.bounds.size.height * -1)){
                    NSLog(@"OUT OF TOP BOUNDS");
                    [self.collision removeItem:anotherView];
                    [self.rocketGravity removeItem:anotherView];
                    [self.enemyGravity removeItem:anotherView];
                    [self.allMovingObjects removeObject:anotherView];
                    [anotherView removeFromSuperview];
                }
                /*
                else if(aView.frame.origin.y >= self.defenceTower.center.y){
                    NSLog(@"COLLIDE BOTTOM BOUNDS with --- %f", aView.frame.origin.y);
                    [self.collision removeItem:aView];
                    [self.rocketGravity removeItem:aView];
                    [self.enemyGravity removeItem:aView];
                    [self.allMovingObjects removeObject:aView];
                    [aView removeFromSuperview];
                }
                else if(anotherView.frame.origin.y >= self.defenceTower.center.y){
                    NSLog(@"COLLIDE BOTTOM BOUNDS with --- %f", anotherView.frame.origin.y);
                    [self.collision removeItem:anotherView];
                    [self.rocketGravity removeItem:anotherView];
                    [self.enemyGravity removeItem:anotherView];
                    [self.allMovingObjects removeObject:anotherView];
                    [anotherView removeFromSuperview];
                }*/
            }
        }
    }
}

- (void)createControls{
    
    CGSize btnSize = CGSizeMake(200*0.3, 319*0.3);
    
    //Left Button
    UIButton *buttonLeft = [UIButton buttonWithType: UIButtonTypeCustom];
    [buttonLeft setBackgroundImage:[UIImage imageNamed:@"buttonLeft.png"] forState:UIControlStateNormal];
    [buttonLeft setFrame:CGRectMake(self.view.bounds.size.width * 0.05 - (btnSize.width/2),
                                      self.view.bounds.size.height-self.view.bounds.size.height*0.2,
                                      btnSize.width,
                                      btnSize.height)];
    [buttonLeft setAlpha:0.3];
    if(buttonLeft.isHighlighted){
        [buttonLeft setAlpha:0.8];
    }
    [self.view addSubview:buttonLeft];
    [buttonLeft addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Right Button
    UIButton *buttonRight = [UIButton buttonWithType: UIButtonTypeCustom];
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"buttonRight.png"] forState:UIControlStateNormal];
    [buttonRight setFrame:CGRectMake(self.view.bounds.size.width - (self.view.bounds.size.width * 0.05) - (btnSize.width/2),
                                    self.view.bounds.size.height-self.view.bounds.size.height*0.2,
                                    btnSize.width,
                                    btnSize.height)];
    [buttonRight setAlpha:0.3];
    if(buttonRight.isHighlighted){
        [buttonRight setAlpha:0.8];
    }
    [self.view addSubview:buttonRight];
    [buttonRight addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];

    //Shoot Touch Area
    UIButton *shootTouchArea = [UIButton buttonWithType: UIButtonTypeCustom];
    //[shootTouchArea setBackgroundColor:[UIColor redColor]];
    [shootTouchArea setFrame:CGRectMake (buttonLeft.bounds.origin.x + buttonLeft.bounds.size.width,
                                         self.view.bounds.size.height/2,
                                         self.view.bounds.size.width - (buttonLeft.bounds.size.width + buttonRight.bounds.size.width),
                                         self.view.bounds.size.height/2)];
    [self.view addSubview:shootTouchArea];
    [shootTouchArea addTarget:self action:@selector(shootTouch:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)leftButton:(id)sender{
    //NSLog(@"left button touched");
    
    
    if([self.defenceTower transform].tx > (self.view.bounds.size.width/3+20)*-1)
      {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.defenceTower setTransform:CGAffineTransformMake(1, 0, 0, 1, self.defenceTower.transform.tx - 20, 0)];
                             
                             
                         }
                         completion:^(BOOL finished){  }];
    }
    
    //NSLog(@"towerX: %f", self.defenceTower.transform.tx);
}

- (IBAction)rightButton:(id)sender{
    //NSLog(@"right button touched");
    
    if([self.defenceTower transform].tx < self.view.bounds.size.width/3 + 20){
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.defenceTower setTransform:CGAffineTransformMake(1, 0, 0, 1, self.defenceTower.transform.tx+20, 0)];
                         }
                         completion:^(BOOL finished){  }];
    }
    //NSLog(@"towerX: %f", self.defenceTower.transform.tx);
}

- (IBAction)shootTouch:(id)sender{
    
    //NSLog(@"SHOOOT! - xPoint: %f", self.defenceTower.frame.origin.x);
    
    // Create PlayerObject
    CGSize rocketSize = CGSizeMake(19, 49);

    UIView *rocketView = [[UIView alloc] initWithFrame:CGRectMake (self.defenceTower.frame.origin.x + 10,
                                                                   self.defenceTower.center.y-self.defenceTower.bounds.size.height-5,
                                                                   rocketSize.width,
                                                                   rocketSize.height)];
    //[rocketView setBackgroundColor:[UIColor redColor]];
    
    // animated ImageView
    UIImageView* rocket = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,rocketSize.width,rocketSize.height)];
    rocket.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"rocket.png"],
                                     [UIImage imageNamed:@"rocket2.png"],nil];
    rocket.animationDuration = 0.5f;
    rocket.animationRepeatCount = 0;
    [rocket startAnimating];
    
    [rocketView addSubview:rocket];
    [self.view addSubview:rocketView];
    //[self.physicsBehavior addItem:self.defenceTower withGravity:NO];
    
    // add particle emitter to rocket
    [rocketView.layer addSublayer:[self createRocketParticles:2 atPosition: CGPointMake(10,50)]];
    
    [self.collision addItem:rocketView];
    [self.rocketGravity addItem:rocketView];
    
    [self.allMovingObjects addObject:rocketView];
    [self setTagID:self.tagID+1];
    //NSLog(@"TagID: %d", self.tagID);
}

- (void)createExplosion:(CGPoint)midPoint{
    
    NSLog(@"createExplosion at point x:%f y:%f", midPoint.x, midPoint.y);
    
    UIView *explosionView = [[UIView alloc] initWithFrame:CGRectMake(midPoint.x,midPoint.y,100,100)];
    CAEmitterLayer *emitter = [self createExplosionParticles:2 atPosition:CGPointMake(explosionView.bounds.size.width/2,
                                                                                      explosionView.bounds.size.height/2)];
    explosionView.layer.zPosition = 20;
    emitter.zPosition = 30;
    
    [explosionView.layer addSublayer:emitter];
    [self.view addSubview:explosionView];
    
    //explosionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [emitter setBirthRate:0.0];
    [emitter setScale:0.0];
    
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:(UIViewAnimationTransitionNone | UIViewAnimationOptionCurveLinear)
                     animations:^{
                         [emitter setBirthRate:50.0];
                         [emitter setScale:5.0];
                     }
                     completion:^(BOOL completed){
                         
                         [NSThread sleepForTimeInterval:0.2f];
                        
                         [UIView animateWithDuration:5.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              [emitter setBirthRate:0.0];
                                              [emitter setScale:0.0];
                                          }
                                          completion:^(BOOL finished){
                                              [NSThread sleepForTimeInterval:1.0f];
                                              [explosionView removeFromSuperview];
                                          }];
                     }];
}

- (CAEmitterLayer *)createRocketParticles:(int)particleId atPosition:(CGPoint)position{
    
    CALayer *particleLayer = [self.view layer];
    NSUInteger smokeNumber = particleId;
    NSString *imageName = [NSString stringWithFormat:@"particle%lu", (unsigned long)smokeNumber];
    [self setImageName:imageName];
    UIImage *image = [UIImage imageNamed:imageName];
    assert(image);
    
    // Setting up the CAEmitterCell
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    [cell setName:imageName];
    float defaultBirthRate = 75.0f;
    [cell setBirthRate:defaultBirthRate];
    [cell setVelocity:60.f];
    [cell setVelocityRange:20.0f];
    [cell setXAcceleration:0.0f];
    [cell setYAcceleration:-1.0f];
    [cell setZAcceleration:0.0f];
    [cell setEmissionLongitude:M_PI_2];
    [cell setEmissionRange:0.0f];
    [cell setScale:0.075f];
    [cell setScaleSpeed:0.2f];
    [cell setScaleRange:0.02f];
    [cell setContents:(id)image.CGImage];
    [cell setColor:[UIColor colorWithRed:0.33
                                   green:0.33
                                    blue:0.33
                                   alpha:0.25].CGColor];
    
    [cell setLifetime:0.75f];
    [cell setLifetimeRange:1.5f];
    /*
    // set life time for iphone or ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [cell setLifetime:6.0f];
        [cell setLifetimeRange:2.0f];
    }
    else {
        [cell setLifetime:0.3f];
        [cell setLifetimeRange:0.1f];
    }*/
    
    // Setting up the CAEmitterLayer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    [self setEmitter:emitter];
    [emitter setEmitterCells:@[cell]];
    CGRect bounds = [self.view bounds];
    [emitter setFrame:bounds];
    CGPoint emitterPosition = position;//(CGPoint) {bounds.size.width*0.5f,bounds.size.height*0.5f};
    [emitter setEmitterPosition:emitterPosition];
    [emitter setEmitterSize:(CGSize){10.0f, 10.0f}];
    [emitter setEmitterShape:kCAEmitterLayerRectangle];
    [emitter setRenderMode:kCAEmitterLayerAdditive];
    [particleLayer addSublayer:emitter];
    [self setEmitter:emitter];
    
    return emitter;
    
}

- (CAEmitterLayer *)createExplosionParticles:(int)particleId atPosition:(CGPoint)position{
    
    CALayer *particleLayer = [self.view layer];
    NSUInteger smokeNumber = particleId;
    NSString *imageName = [NSString stringWithFormat:@"particle%lu", (unsigned long)smokeNumber];
    [self setImageName:imageName];
    UIImage *image = [UIImage imageNamed:imageName];
    assert(image);
    
    // Setting up the CAEmitterCell
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    [cell setName:imageName];
    float defaultBirthRate = 30.0f;
    [cell setBirthRate:defaultBirthRate];
    [cell setVelocity:0];
    [cell setVelocityRange:0];
    [cell setYAcceleration:0];
    [cell setEmissionLongitude:M_PI_4];
    [cell setEmissionRange:0];
    [cell setScale:0.1f];
    [cell setScaleSpeed:0.3f];
    [cell setScaleRange:0.1f];
    [cell setContents:(id)image.CGImage];
    [cell setColor:[UIColor colorWithRed:1.0
                                   green:0.2
                                    blue:0.1
                                   alpha:0.5].CGColor];
    [cell setLifetime:0.5f];
    [cell setLifetimeRange:0.5f];
    
    // Setting up the CAEmitterLayer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    [self setEmitter:emitter];
    [emitter setEmitterCells:@[cell]];
    CGRect bounds = [self.view bounds];
    [emitter setFrame:bounds];
    CGPoint emitterPosition = position;
    [emitter setEmitterPosition:emitterPosition];
    [emitter setEmitterSize:(CGSize){10.0f, 10.0f}];
    [emitter setEmitterShape:kCAEmitterLayerRectangle];
    [emitter setRenderMode:kCAEmitterLayerAdditive];
    [particleLayer addSublayer:emitter];
    [self setEmitter:emitter];
    
    return emitter;
    
}

- (void)setShorterTimeIntervall{
    [self setTimeIntervall:self.timeIntervall-0.5];
    //NSLog(@"TimeIntervall: %f", self.timeIntervall);
}

- (void)createBgGradient{
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:(195/255.0)
                                                green:(239/255.0)
                                                 blue:(253/255.0)
                                                alpha:(255/255)].CGColor,
                            (id)[UIColor colorWithRed:(112/255.0)
                                                green:(173/255.0)
                                                 blue:(251/255.0)
                                                alpha:(255/255)].CGColor, nil];
    self.gradient.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:0.7f],
                               nil];
    // set start and end points for gradient
    self.gradient.startPoint = CGPointMake(1.0, 1.0);
    self.gradient.endPoint = CGPointMake(1.0, 0.0);
    
    // lay in background
    [self.gradient.sublayers lastObject];
    
    // bring back button to foreground
    [self.backButton.layer setZPosition:10];
    
    // add gradient to UIView
    [self.view.layer addSublayer:self.gradient];
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max{
    int rnd = min + arc4random() % (max - min + 1);
    //NSLog(@"randomNumber %d", rnd);
    return rnd;
}

@end
