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
	if( (self=[super init]) ) {
        self.game = [[GameObject alloc] init];
        self.game.gameGridLayer = self;
        [self setupGameGrid];
	}
	return self;
}

- (void) setupGameGrid
{
//    CGSize size = [[CCDirector sharedDirector] winSize];
    [self.game drawGridsAtOrigin:CGPointMake(gameGridOffsetX, gameGridOffsetY)];
}


- (void) dealloc
{
	[super dealloc];
}


@end
