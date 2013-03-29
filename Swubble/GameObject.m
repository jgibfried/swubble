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
    
    return [[NSArray alloc] initWithObjects:type1, type2, type3, nil];
}

- (Bubble *) getNewBubble
{
    int randomNumber = ((arc4random() % 3) + 1) - 1  ;
    Bubble *bubble = [Bubble initWithData:[self.bubbleTypes objectAtIndex:randomNumber]];
    bubble.touchDelegate = self;
    return bubble;
}

- (Bubble *) addNewBubbleInCell:(GameGridCell *)cell
{
    Bubble *newBubble = [self getNewBubble];
    newBubble.cellPosition = cell.position;
    newBubble.gridNumber = cell.gridNumber;
    newBubble.position = cell.bubblePosition;
    cell.bubble = newBubble;
    [self.gameGridLayer addChild:cell.bubble];
    return newBubble;
}

- (Bubble *) addNewBubbleAtPosition: (CGPoint) position forCell: (GameGridCell *) cell
{
    Bubble *newBubble = [self getNewBubble];
    newBubble.cellPosition = cell.position;
    newBubble.gridNumber = cell.gridNumber;
    newBubble.position = position;
    cell.bubble = newBubble;
    [self.gameGridLayer addChild:cell.bubble];
    return newBubble;
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

- (void)fixBubbles
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        NSLog(@"Grid %d", idx);
        [grid.grid enumerateObjectsUsingBlock:^(NSMutableArray *column, NSUInteger idx, BOOL *stop) {
            [column enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
                
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

- (GameGridCell *) getNextEmptyCell
{
    for (GameGrid *grid in self.grids) {
        for (NSArray *row in grid.grid) {
            for (GameGridCell *cell in row) {
                if (!cell.bubble) {
                    return cell;
                }
            }
        }
    }
    return nil;
}

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

- (void) fillEmptyCells
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger gridIdx, BOOL *stop) {
        [grid.grid enumerateObjectsUsingBlock:^(NSMutableArray *column, NSUInteger columnIdx, BOOL *stop) {
            NSMutableArray *bubbles = [[NSMutableArray alloc] init];
            NSMutableArray *cells = [[NSMutableArray alloc] init];
            for (GameGridCell *cell in column) {
                if (cell.bubble) {
                    [bubbles addObject:cell.bubble];
                }
                [cells addObject:cell];
            }
            
            if ([cells count] > [bubbles count]) {
                [cells enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
                    Bubble *bubble = nil;
                    if (idx >= [bubbles count]) {
                        bubble = [self addNewBubbleAtPosition:CGPointMake(cell.bubblePosition.x, 900)];
                        bubble.gridNumber = cell.gridNumber;
                    } else {
                        bubble = [bubbles objectAtIndex:idx];
                    }

                    if (cell.gridNumber == bubble.gridNumber && (cell.bubblePosition.x != bubble.position.x || cell.bubblePosition.y != bubble.position.y) && bubble != nil) {
                        [bubble runAction:
                         [CCSequence actions:
                          [CCCallBlock actionWithBlock:^(void){
                             bubble.moving = YES;
                             [bubble runAction:[CCMoveTo actionWithDuration:0.3 position:ccp(cell.bubblePosition.x, cell.bubblePosition.y)]];
                         }],
                          [CCDelayTime actionWithDuration:0.4],
                          [CCCallBlock actionWithBlock:^(void){
                             bubble.moving = NO;
                         }],
                          nil]];

                        [cell setBubble: bubble];
                    }
                }];
            }
        }];
    }];
}

/* Match Checking ******************************/

- (NSArray *) getMatches: (GameGridCell *)cell
{
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    
    NSMutableArray *verticleMatches = [[NSMutableArray alloc] init];
    [verticleMatches addObject:cell];
    [verticleMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionUp withArray:verticleMatches]];
    [verticleMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionDown withArray:verticleMatches]];
    
    NSMutableArray *horizontalMatches = [[NSMutableArray alloc] init];
    [horizontalMatches addObject:cell];
    [horizontalMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionLeft withArray:horizontalMatches]];
    [horizontalMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionRight withArray:horizontalMatches]];
    
    [matches addObject:verticleMatches];
    [matches addObject:horizontalMatches];
    
    return matches;
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

- (void) destroyMatches: (NSArray *) matches
{
    for (GameGridCell *cell in matches) {
        if (cell.bubble) {
            Bubble *bubble = cell.bubble;
            [bubble.parent removeChild:bubble cleanup:YES];
            cell.bubble = nil;
        }
    }
    [self fillEmptyCells];
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
        
        NSArray *matches1 = [self getMatches:cell1];
        
        NSArray *vMatches1 = [matches1 objectAtIndex:0];
        NSArray *hMatches1 = [matches1 objectAtIndex:1];
        
        NSArray *matches2 = [self getMatches:cell2];
        
        NSArray *vMatches2 = [matches2 objectAtIndex:0];
        NSArray *hMatches2 = [matches2 objectAtIndex:1];
        
        if ([vMatches2 count] < 3 && [hMatches2 count] < 3 && [vMatches1 count] < 3 && [hMatches1 count] < 3) {
            [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
                [cell1 setBubble: bubble1];
                [cell2 setBubble: bubble2];
            } inReverse:NO];
        } else {
            NSMutableArray *matchesToDestroy = [[NSMutableArray alloc] init];
            if ([vMatches1 count] >= 3) {
                [matchesToDestroy addObjectsFromArray:vMatches1];
            }
            if ([vMatches2 count] >= 3) {
                [matchesToDestroy addObjectsFromArray:vMatches2];
            }
            if ([hMatches1 count] >= 3) {
                [matchesToDestroy addObjectsFromArray:hMatches1];
            }
            if ([hMatches2 count] >= 3) {
                [matchesToDestroy addObjectsFromArray:hMatches2];
            }
            [self destroyMatches:matchesToDestroy];
        }
    } inReverse:NO];
}

- (void) animateSwap: (GameGridCell *) cell1 withCell: (GameGridCell *) cell2 withHandler: (HandlerBlock) handler inReverse: (BOOL) reverse
{
    CGPoint cell1BubblePosition = cell1.bubblePosition;
    CGPoint cell2BubblePosition = cell2.bubblePosition;
    
    [cell1.bubble runAction:
     [CCSequence actions:
      [CCCallBlock actionWithBlock:^(void){
         cell1.bubble.moving = YES;
         cell2.bubble.moving = YES;
         [cell1.bubble runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(cell2BubblePosition.x, cell2BubblePosition.y)]];
         [cell2.bubble runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(cell1BubblePosition.x, cell1BubblePosition.y)]];
        }],
      [CCDelayTime actionWithDuration:0.7],
      [CCCallBlock actionWithBlock:^(void){
         cell1.bubble.moving = NO;
         cell2.bubble.moving = NO;
        }],
      [CCCallBlock actionWithBlock:handler],
      nil]];
}

@end
