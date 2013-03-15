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
        [self setupGameGrid];
	}
	return self;
}

- (void) setupGameGrid
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    Bubble *bubble = [Bubble getNewBubble];
    
    bg.position =  ccp( size.width /2 , size.height/2 );
    [self addChild:bg z:0];
}


- (void) dealloc
{
	[super dealloc];
}


@end
