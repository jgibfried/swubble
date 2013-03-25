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
        self.spriteColors = [[NSArray alloc] initWithObjects:redBubbleSprite, greenBubbleSprite, nil];
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
    __block int bubbleId = 0;
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        for(NSMutableArray *column in grid.grid)
        {
            for (GameGridCell *cell in column)
            {
                int randomNumber = ((arc4random() % 2) + 1) - 1  ;
                
                cell.bubble = [[Bubble alloc] initWithFile:[self.spriteColors objectAtIndex:randomNumber]];
                cell.bubble.bubbleId = bubbleId++;
                cell.bubble.touchDelegate = self;
                cell.bubble.cellPosition = cell.position;
                cell.bubble.gridNumber = idx;
            }
        }
    }];
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
                cell.bubble.position = ccp(xPosition, yPosition);
                [layer addChild: cell.bubble];
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

- (GameGrid *)getOppositeGrid: (int) originalIndex
{
    if (originalIndex == 0) {
        return [self.grids objectAtIndex:1];
    }else{
        return [self.grids objectAtIndex:0];
    }
}

- (void) bubbleSwitchGrid:(Bubble *) thisBubble {
    
    Bubble *originalBubble = thisBubble;
    CGPoint originalPosition = thisBubble.position;
    
    GameGrid *otherGrid = [self getOppositeGrid:thisBubble.gridNumber];
    GameGridCell *cellToSwap = [otherGrid getCellForPosition:thisBubble.cellPosition];
    
    Bubble *bubbleToSwap = cellToSwap.bubble;
    
    [thisBubble setPosition:bubbleToSwap.position];
    [bubbleToSwap setPosition:originalPosition];
    
    GameGrid *thisGrid = [self.grids objectAtIndex:thisBubble.gridNumber];
    GameGridCell *originalCell = [thisGrid getCellForPosition:thisBubble.cellPosition];

    bubbleToSwap.gridNumber = originalBubble.gridNumber;
    originalBubble.gridNumber = bubbleToSwap.gridNumber;
    
    [originalCell setBubble: bubbleToSwap];
    [cellToSwap setBubble: originalBubble];    
}

@end
