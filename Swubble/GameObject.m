//
//  GameObject.m
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize gameTimeLeft;
@synthesize gameTimeSpent;
@synthesize totalScore;
@synthesize totalBonuses;
@synthesize difficultyLevel;

@synthesize gameTimer;

- (id)init
{
    if( (self=[super init]) ) {
        self.gameTimeLeft = gameTimeDefault;
        self.grids = [NSArray arrayWithObjects:[GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)], [GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)], nil];
    }
	return self;
}

- (void)startGame
{
    [self startTimeClock];
}

- (void)populateGrids
{
    for(GameGrid *grid in self.grids)
    {
        for(NSMutableArray *column in grid.grid)
        {
            for (GameGridCell *cell in column)
            {
                cell.bubble = [[Bubble alloc] init];
            }
        }
    }
}


- (void)drawGridsOnLayer: (CCLayer *)layer atOrigin: (CGPoint) origin
{
    [self populateGrids];
    float xPosition = origin.x;
    float yPosition = origin.y;
    
    for(GameGrid *grid in self.grids)
    {
        for(NSMutableArray *column in grid.grid)
        {
            for (GameGridCell *cell in column)
            {
                cell.bubble.sprite.position = ccp(xPosition, yPosition);
                [layer addChild: cell.bubble.sprite];
                yPosition = (yPosition + gameGridCellHeight);
            }
            yPosition = origin.y;
            xPosition = (xPosition + gameGridCellWidth);
        }
        xPosition = (xPosition + gameGridCellWidth);
    }
}


- (void)startTimeClock
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
