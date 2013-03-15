//
//  GameEngine.m
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameEngine.h"

@implementation GameEngine

-(id) init
{
	if( (self=[super init]) ) {
        self.currentGame = [self getNewGame];
	}
	return self;
}

-(GameObject *) getNewGame
{
    return [[GameObject alloc] init];
}

@end
