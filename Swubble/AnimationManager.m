//
//  AnimationManager.m
//  Swubble
//
//  Created by John Gibfried on 4/5/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager

@synthesize actionList;

-(id) initWithBubble: (Bubble *) bubble
{
    self = [super init];
	if(self) {
        self.bubble = bubble;
    }
	return self;
}

- (void) addAction: (id) action
{
    [self.actionList addObject:action];
}

- (void) clearActionList
{
    [self.actionList removeAllObjects];
}


@end
