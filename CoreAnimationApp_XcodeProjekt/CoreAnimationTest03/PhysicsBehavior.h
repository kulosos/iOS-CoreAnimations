//
//  DropitBehavior.h
//  Dropit
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhysicsBehavior : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item withGravity:(BOOL)withGravity;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
