//
//  GameObject.m
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize gameGridLayer;

@synthesize matchesToDestroy;
@synthesize gameTimeLeft;
@synthesize gameTimeSpent;
@synthesize totalScore;
@synthesize totalBonuses;
@synthesize difficultyLevel;

@synthesize gameTimer;

int maxCount = 0;

- (id)init
{
    if( (self=[super init]) ) {
        self.gameTimeLeft = gameTimeDefault;
        self.grids = [NSArray arrayWithObjects:[GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)], [GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)], nil];
        self.matchesToDestroy = [NSMutableSet set];
    }
	return self;
}

- (void)startGame
{
    [self startTimeClock];
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

/* Bubble Utility Methods ******************************/

- (NSArray *) bubbleTypes
{
    NSDictionary *type1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", redBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", greenBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type3 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"3", yellowBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    
    return [NSArray arrayWithObjects: type1, type2, type3, nil];
}

- (Bubble *) getNewBubble
{
    int randomNumber = ((arc4random() % 3) + 1) - 1  ;
    Bubble *bubble = [Bubble initWithData:[self.bubbleTypes objectAtIndex:randomNumber]];
    bubble.touchDelegate = self;
    return bubble;
}

- (Bubble *) addNewBubbleAtPosition: (CGPoint) position
{
    Bubble *newBubble = [self getNewBubble];
    newBubble.position = position;
    [self.gameGridLayer addChild:newBubble];
    return newBubble;
}


/* Grid Utility Methods ******************************/

- (GameGridCell *) cellOnGrid: (int) gridNumber atPosition: (CGPoint) position
{
    GameGrid *grid = [self.grids objectAtIndex:gridNumber];
    return [grid getCellForPosition:position];
}

- (BOOL) positionIsOutOfBounds: (CGPoint) cellPosition
{
    if (cellPosition.x >= 0 && cellPosition.y >=0 && cellPosition.x <= gameGridSizeWidth && cellPosition.y <= gameGridSizeHeight){
        return NO;
    }
    return YES;
}

- (void)populateGrids
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger gridIdx, BOOL *stop) {
        [grid.grid enumerateObjectsUsingBlock:^(NSMutableArray *column, NSUInteger idx, BOOL *stop) {
            [column enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
                cell.gridNumber = gridIdx;
                [cell setBubble:[self getNewBubble]];
            }];
        }];
    }];
}

- (void)drawGridsAtOrigin: (CGPoint) origin
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
                cell.bubblePosition = ccp(xPosition, yPosition);
                cell.bubble.position = ccp(xPosition, yPosition);
                [self.gameGridLayer addChild: cell.bubble];
                yPosition = (yPosition + gameGridCellHeight);
            }
            yPosition = origin.y;
            xPosition = (xPosition + gameGridCellWidth);
        }
        xPosition = (xPosition + gameGridCellWidth);
    }
    [self check];
}

- (int) oppositeGridNumber: (int) idx
{
    return idx == 0 ? 1 : 0;
}


- (CGPoint) getNextPosition: (CGPoint) position forDirection: (DragDirection) direction
{
    CGPoint newPosition;
    switch (direction) {
        case kDirectionDown:
            newPosition = CGPointMake(position.x, position.y-1);
            break;
            
        case kDirectionUp:
            newPosition = CGPointMake(position.x, position.y+1);
            break;
            
        case kDirectionLeft:
            newPosition = CGPointMake(position.x+1, position.y);
            break;
            
        case kDirectionRight:
            newPosition = CGPointMake(position.x-1, position.y);
            break;
            
        default:
            break;
    }
    return newPosition;
}

/* Cell Population Methods ******************************/

- (GameGridCell *) getNextPopulatedCell: (CGPoint) cellPosition inDirection: (DragDirection) direction onGrid: (int) gridNumber
{
    CGPoint newPosition = [self getNextPosition:cellPosition forDirection:direction];
    if ([self positionIsOutOfBounds:newPosition]) {
        return nil;
    }
    GameGridCell *nextCell = [self cellOnGrid:gridNumber atPosition:newPosition];
    while (nextCell.bubble == nil) {
        newPosition = [self getNextPosition:nextCell.position forDirection:direction];
        if ([self positionIsOutOfBounds:newPosition]) {
            return nil;
        }
        nextCell = [self cellOnGrid:gridNumber atPosition:newPosition];
    }
    return nextCell;
}

/* Match Checking ******************************/

- (BOOL) check
{
	[self checkForMatches];
	
	NSArray *objects = [[self.matchesToDestroy objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}
	
    for (GameGridCell *cell in self.matchesToDestroy) {
        if (cell.bubble) {
            Bubble *bubble = cell.bubble;
            cell.bubble = nil;
            CCAction *action = [CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:0.0],
                                [CCCallFuncN actionWithTarget: self selector:@selector(removeBubble:)],
                                nil];
            [bubble runAction: action];
        }
    }

	[self.matchesToDestroy removeAllObjects];
	
	[self.gameGridLayer runAction: [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 0.3 + 0.03],
                                    [CCCallFunc actionWithTarget:self selector:@selector(fillEmptyCells)],
                                    [CCDelayTime actionWithDuration: 0.2 * maxCount + 0.03],
                                    [CCCallFunc actionWithTarget:self selector:@selector(afterAllMoveDone)],
                                    nil]];
	return YES;
}

- (void) removeBubble: (id) sender{
	[self.gameGridLayer removeChild: sender cleanup:YES];
}

- (void) afterAllMoveDone{
    [self check];
}

//-(void) unlock{
//	self.lock = NO;
//}
//

- (void) checkForMatches
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        [grid.grid enumerateObjectsUsingBlock:^(NSMutableArray *column, NSUInteger idx, BOOL *stop) {
            [column enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
                NSArray *matches1 = [self getMatches:cell];
                
                NSArray *vMatches1 = [matches1 objectAtIndex:0];
                NSArray *hMatches1 = [matches1 objectAtIndex:1];
                
                if ([vMatches1 count] >= 3) {
                    [self.matchesToDestroy addObjectsFromArray:vMatches1];
                }
                if ([hMatches1 count] >= 3) {
                    [self.matchesToDestroy addObjectsFromArray:hMatches1];
                }
            }];
        }];
    }];
}

- (NSArray *) getMatches: (GameGridCell *)cell
{
    NSMutableArray *verticleMatches = [NSMutableArray arrayWithObject:cell];
    [self checkForMatch:cell inDirection:kDirectionUp withArray:verticleMatches];
    [self checkForMatch:cell inDirection:kDirectionDown withArray:verticleMatches];
    
    NSMutableArray *horizontalMatches = [NSMutableArray arrayWithObject:cell];
    [self checkForMatch:cell inDirection:kDirectionLeft withArray:horizontalMatches];
    [self checkForMatch:cell inDirection:kDirectionRight withArray:horizontalMatches];
    
    return [NSArray arrayWithObjects:verticleMatches, horizontalMatches, nil];
}

-(NSArray *) checkForMatch:  (GameGridCell *)cell inDirection: (DragDirection) direction withArray: (NSMutableArray *) matches
{
    CGPoint newPosition = [self getNextPosition:cell.position forDirection:direction];
    
    if (![self positionIsOutOfBounds:newPosition]){
        GameGridCell *cellToCheck = [self cellOnGrid:cell.bubble.gridNumber atPosition:newPosition];
        if ([cell.bubble.type isEqualToString:cellToCheck.bubble.type]) {
            [matches addObject:cellToCheck];
            return [self checkForMatch:cellToCheck inDirection:direction withArray:matches];
        }
    }
    return matches;
}


- (void) fillEmptyCells
{
	maxCount = 0;
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        [grid.grid enumerateObjectsUsingBlock:^(NSArray *column, NSUInteger idx, BOOL *stop) {
            int count = [self fillSingleColumn:column];
            if (count > maxCount) {
                maxCount = count;
            }
        }];
    }];
}

- (int) fillSingleColumn: (NSArray *) column
{
	__block int extension = 0;
    [column enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
        if (cell.bubble == nil) {
           	extension++;
            Bubble *bubble = nil;
            GameGridCell *cellToCheck = [self getNextPopulatedCell:cell.position inDirection:kDirectionUp onGrid:cell.gridNumber];
            if (cellToCheck == nil) {
                bubble = [self addNewBubbleAtPosition:CGPointMake(cell.bubblePosition.x, 900)];
                bubble.gridNumber = cell.gridNumber;
            } else {
                bubble = cellToCheck.bubble;
                [cellToCheck setBubble:nil];
            }
            
            CCSequence *action = [CCSequence actions:
                                  [CCMoveTo actionWithDuration:0.2 position:ccp(cell.bubblePosition.x, cell.bubblePosition.y)],
                                  nil];
            
            [bubble runAction: action];
            [cell setBubble: bubble];
        }
    }];
    return extension;
}

/* Bubble Movement ******************************/

- (void) bubbleSwitchGrid:(Bubble *) bubble {

    Bubble *bubble1 = bubble;
    
    CGPoint cell1Position = bubble1.cellPosition;
    int grid1Number = bubble1.gridNumber;
    
    GameGridCell *cell2 =  [self cellOnGrid:[self oppositeGridNumber:bubble1.gridNumber] atPosition:bubble1.cellPosition];
    if (!cell2.bubble) {
        return;
    }
    
    CGPoint cell2Position = cell2.position;
    int grid2Number = cell2.gridNumber;
    
    [self moveBubbleFromPosition:cell1Position withGrid:grid1Number toPosition:cell2Position withGrid:grid2Number];
}

- (void) bubbleSwap: (NSDictionary *) data
{
    Bubble *bubble = [data objectForKey:@"bubble"];
    DragDirection direction = [[data valueForKey:@"direction"] intValue];
    
    Bubble *bubble1 = bubble;
    
    CGPoint cell1Position = bubble1.cellPosition;
    int grid1Number = bubble1.gridNumber;
    
    CGPoint cell2Position = [self getNextPosition:cell1Position forDirection:direction];

    [self moveBubbleFromPosition:cell1Position withGrid:grid1Number toPosition:cell2Position withGrid:grid1Number];
}

- (void) moveBubbleFromPosition: (CGPoint) cell1Position withGrid: (int) grid1Number toPosition: (CGPoint) cell2Position withGrid: (int) grid2Number
{
    if ([self positionIsOutOfBounds:cell1Position] || [self positionIsOutOfBounds:cell2Position]){
        return;
    }
    
    GameGridCell *cell1 =  [self cellOnGrid:grid1Number atPosition:cell1Position];
    GameGridCell *cell2 =  [self cellOnGrid:grid2Number atPosition:cell2Position];
    
    Bubble *bubble1 = cell1.bubble;
    if (!bubble1) {
        return;
    }
    
    Bubble *bubble2 = cell2.bubble;
    if (!bubble2) {
        return;
    }
    [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
        
        [cell2 setBubble: bubble1];
        [cell1 setBubble: bubble2];
        
        if ([self check] == NO) {
            [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
                [cell1 setBubble: bubble1];
                [cell2 setBubble: bubble2];
            }];
        }
    }];
}

- (void) animateSwap: (GameGridCell *) cell1 withCell: (GameGridCell *) cell2 withHandler: (HandlerBlock) handler
{
    CGPoint cell1BubblePosition = cell1.bubblePosition;
    CGPoint cell2BubblePosition = cell2.bubblePosition;
    
    [self.gameGridLayer runAction:
             [CCSequence actions:
              [CCCallBlock actionWithBlock:^(void){
                 [cell1.bubble runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(cell2BubblePosition.x, cell2BubblePosition.y)]];
                 [cell2.bubble runAction:[CCMoveTo actionWithDuration:0.25 position:ccp(cell1BubblePosition.x, cell1BubblePosition.y)]];
             }],
              [CCDelayTime actionWithDuration:0.5],
              [CCCallBlock actionWithBlock:handler],
              nil]];
}

- (void) setValidMatches: (GameGridCell *) cell
{
    NSArray *matches1 = [self getMatches:cell];
    
    NSArray *vMatches1 = [matches1 objectAtIndex:0];
    NSArray *hMatches1 = [matches1 objectAtIndex:1];

    if ([vMatches1 count] >= 3) {
        [self.matchesToDestroy addObjectsFromArray:vMatches1];
    }
    if ([hMatches1 count] >= 3) {
        [self.matchesToDestroy addObjectsFromArray:hMatches1];
    }
}

@end
