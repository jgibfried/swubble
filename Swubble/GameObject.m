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

- (int) oppositeGridNumber: (int) idx
{
    return idx == 0 ? 1 : 0;
}

- (GameGrid *)getOppositeGrid: (int) originalIndex
{
    if (originalIndex == 0) {
        return [self.grids objectAtIndex:1];
    }else{
        return [self.grids objectAtIndex:0];
    }
}

- (GameGridCell *) cellOnGrid: (int) gridNumber atPosition: (CGPoint) position
{
    GameGrid *grid = [self.grids objectAtIndex:gridNumber];
    return [grid getCellForPosition:position];
}

- (void) animateSwap: (GameGridCell *) cell1 withCell: (GameGridCell *) cell2
{
    Bubble *thisBubble = cell1.bubble;
    Bubble *bubbleToSwap = cell2.bubble;
    CGPoint originalPosition = thisBubble.position;
    
    int xMove = bubbleToSwap.position.x-originalPosition.x;
    int yMove = bubbleToSwap.position.y-originalPosition.y;
    
    [thisBubble runAction:[CCMoveBy actionWithDuration:0.5 position:ccp(xMove, yMove)]];
    [bubbleToSwap runAction:[CCMoveBy actionWithDuration:0.5 position:ccp(-xMove, -yMove)]];
}

- (void) bubbleSwitchGrid:(Bubble *) thisBubble {
    
    Bubble *originalBubble = thisBubble;
    
    GameGridCell *originalCell =  [self cellOnGrid:thisBubble.gridNumber atPosition:thisBubble.cellPosition];
    
    int originalGridnumber = thisBubble.gridNumber;
    
    GameGridCell *cellToSwap =  [self cellOnGrid:[self oppositeGridNumber:thisBubble.gridNumber] atPosition:thisBubble.cellPosition];
    
    [self animateSwap:originalCell withCell:cellToSwap];
    
    thisBubble.gridNumber = cellToSwap.bubble.gridNumber;
    cellToSwap.bubble.gridNumber = originalGridnumber;
    
    [originalCell setBubble: cellToSwap.bubble];
    [cellToSwap setBubble: originalBubble];    
}

- (void) bubbleSwap: (NSDictionary *) data
{
    Bubble *thisBubble = [data objectForKey:@"bubble"];
    DragDirection direction = [[data valueForKey:@"direction"] intValue];
    
    CGPoint originalCellPosition = thisBubble.cellPosition;
    
    GameGridCell *originalCell = [self cellOnGrid:thisBubble.gridNumber atPosition:thisBubble.cellPosition];

    CGPoint newPosition;
    switch (direction) {
        case kDirectionDown:
            newPosition = CGPointMake(originalCell.position.x, originalCell.position.y-1);
            break;
        
        case kDirectionUp:
            newPosition = CGPointMake(originalCell.position.x, originalCell.position.y+1);
            break;
        
        case kDirectionLeft:
            newPosition = CGPointMake(originalCell.position.x+1, originalCell.position.y);
            break;

        case kDirectionRight:
            newPosition = CGPointMake(originalCell.position.x-1, originalCell.position.y);
            break;
            
        default:
            break;
    }
    
    if (newPosition.x >= 0 && newPosition.y >=0 && newPosition.x <= gameGridSizeWidth && newPosition.y <= gameGridSizeHeight){
        GameGridCell *cellToSwap = [self cellOnGrid:thisBubble.gridNumber atPosition:newPosition];
        
        [self animateSwap:originalCell withCell:cellToSwap];
        
        thisBubble.cellPosition = cellToSwap.bubble.cellPosition;
        cellToSwap.bubble.cellPosition = originalCellPosition;
        
        [originalCell setBubble: cellToSwap.bubble];
        [cellToSwap setBubble: thisBubble];
    }
}

@end
