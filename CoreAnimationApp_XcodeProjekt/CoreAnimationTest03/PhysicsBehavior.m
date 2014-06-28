//
//  DropitBehavior.m
//  Dropit
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "PhysicsBehavior.h"

@interface PhysicsBehavior()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
@end

@implementation PhysicsBehavior

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.02;
        //_gravity.gravityDirection = cos;
    }
    return _gravity;
}

- (UICollisionBehavior *)collider
{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = NO;
    }
    return _collider;
}

- (void)addItem:(id <UIDynamicItem>)item withGravity:(BOOL)withGravity
{
    if(withGravity){
        [self.gravity addItem:item];
    }
    [self.collider addItem:item];
}

- (void)removeItem:(id <UIDynamicItem>)item;
{
    if(!_gravity){
        [self.gravity removeItem:item];
    }
    [self.collider removeItem:item];
}

- (instancetype)init
{
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    return self;
}

@end
