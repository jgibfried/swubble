//
//  GameGridLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/11/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameGridLayer.h"

@implementation GameGridLayer


-(id) init
{
    self = [super init];
	if(self) {
        [self setupGameGrid];
	}
	return self;
}

- (void) setupGameGrid
{
    GameObject *game = [[GameObject alloc] init];
    game.gameGridLayer = self;
    
    self.game = game;
    [self.game drawGridsAtOrigin:CGPointMake(gameGridOffsetX, gameGridOffsetY)];
}


- (void) dealloc
{
	[super dealloc];
}


@end
