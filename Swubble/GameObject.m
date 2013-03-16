//
//  GameObject.m
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize leftGrid;
@synthesize rightGrid;

@synthesize gameTimeLeft;
@synthesize gameTimeSpent;
@synthesize totalScore;
@synthesize totalBonuses;
@synthesize difficultyLevel;

@synthesize gameTimer;

- (GameObject *)startGame
{
    [self startTimeClock];
    return self;
}

- (id)init
{
    if( (self=[super init]) ) {
        self.gameTimeLeft = gameTimeDefault;
        self.rightGrid = [GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)];
        self.leftGrid = [GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)];
	}
	return self;
}

- (void) startTimeClock
{
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(second:)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)second:(NSTimer *)timer
{
    self.gameTimeSpent++;
    self.gameTimeLeft--;
    
    if (gameTimeLeft <= 0) 
        [gameTimer invalidate]; 
}

@end
