//
//  MenuBackgroundLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/7/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "MenuBackgroundLayer.h"

@implementation MenuBackgroundLayer

-(id) init
{
	if( (self=[super init]) ) {
        [self setupBackground];
	}
	return self;
}

- (void) setupBackground
{
    CCSprite *bg = [CCSprite spriteWithFile: menuBackground];
    bg.position =  ccp( self.windowSize.width /2 , self.windowSize.height/2 );
    [self addChild:bg z:0];
}

@end
