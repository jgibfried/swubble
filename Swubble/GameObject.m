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

- (NSArray *) bubbleTypes
{
    NSDictionary *type1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", redBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", greenBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    
    return [[NSArray alloc] initWithObjects:type1, type2, nil];
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
                
                cell.bubble = [Bubble initWithData:[self.bubbleTypes objectAtIndex:randomNumber]];
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

-(NSArray *) getVerticalMatchesForCell: (GameGridCell *)cell 
{
    NSMutableArray *verticleMatches = [[NSMutableArray alloc] init];
 
    [verticleMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionUp withArray:verticleMatches]];
    [verticleMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionDown withArray:verticleMatches]];

    return verticleMatches;
}

-(NSArray *) getHorizontalMatchesForCell: (GameGridCell *)cell 
{
    NSMutableArray *horizontalMatches = [[NSMutableArray alloc] init];

    [horizontalMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionLeft withArray:horizontalMatches]];
    [horizontalMatches arrayByAddingObjectsFromArray:[self checkForMatch:cell inDirection:kDirectionRight withArray:horizontalMatches]];

    return horizontalMatches;
}


-(NSArray *) checkForMatch:  (GameGridCell *)cell inDirection: (DragDirection) direction withArray: (NSMutableArray *) matches
{
    CGPoint newPosition;
    switch (direction) {
        case kDirectionDown:
            NSLog(@"Direction: Down");
            newPosition = CGPointMake(cell.position.x, cell.position.y-1);
            break;
            
        case kDirectionUp:
            NSLog(@"Direction: Up");
            newPosition = CGPointMake(cell.position.x, cell.position.y+1);
            break;
            
        case kDirectionLeft:
            NSLog(@"Direction: Left");
            newPosition = CGPointMake(cell.position.x+1, cell.position.y);
            break;
            
        case kDirectionRight:
            NSLog(@"Direction: Right");
            newPosition = CGPointMake(cell.position.x-1, cell.position.y);
            break;
            
        default:
            break;
    }

    if (newPosition.x >= 0 && newPosition.y >=0 && newPosition.x <= gameGridSizeWidth && newPosition.y <= gameGridSizeHeight){
        GameGridCell *cellToCheck = [self cellOnGrid:cell.bubble.gridNumber atPosition:newPosition];
        if ([cell.bubble.type isEqualToString:cellToCheck.bubble.type]) {
            [matches addObject:cellToCheck];
            return [self checkForMatch:cellToCheck inDirection:direction withArray:matches];
        }
    }
    return matches;
}


- (GameGridCell *) cellOnGrid: (int) gridNumber atPosition: (CGPoint) position
{
    GameGrid *grid = [self.grids objectAtIndex:gridNumber];
    return [grid getCellForPosition:position];
}

- (void) animateSwap: (GameGridCell *) cell1 withCell: (GameGridCell *) cell2 withHandler: (HandlerBlock) handler inReverse: (BOOL) reverse
{
    int xMove = 0;
    int yMove = 0;
    
    if (reverse) {
        xMove = cell1.bubble.position.x-cell2.bubble.position.x;
        yMove = cell1.bubble.position.y-cell2.bubble.position.y;
    } else {
        xMove = cell2.bubble.position.x-cell1.bubble.position.x;
        yMove = cell2.bubble.position.y-cell1.bubble.position.y;
    }
    
    [cell1.bubble runAction:
         [CCSequence actions:
         [CCCallBlock actionWithBlock:^(void){
             if (reverse) {
                 [cell1.bubble runAction:[CCMoveBy actionWithDuration:0.5 position:ccp(-xMove, -yMove)]];
                 [cell2.bubble runAction:[CCMoveBy actionWithDuration:0.5 position:ccp(xMove, yMove)]];
             }else{
                 [cell1.bubble runAction:[CCMoveBy actionWithDuration:0.5 position:ccp(xMove, yMove)]];
                 [cell2.bubble runAction:[CCMoveBy actionWithDuration:0.5 position:ccp(-xMove, -yMove)]];
             }
         }],
         [CCDelayTime actionWithDuration:0.7],
         [CCCallBlock actionWithBlock:handler],
         nil]];
}

- (void) bubbleSwitchGrid:(Bubble *) bubble {
    
    Bubble *bubble1 = bubble;
    
    GameGridCell *cell1 =  [self cellOnGrid:bubble1.gridNumber atPosition:bubble1.cellPosition];
    
    int bubble1GridNumber = bubble1.gridNumber;
    
    GameGridCell *cell2 =  [self cellOnGrid:[self oppositeGridNumber:bubble1.gridNumber] atPosition:bubble1.cellPosition];
    
    Bubble *bubble2 = cell2.bubble;
    
    int bubble2GridNumber = bubble2.gridNumber;
    
    [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
        bubble1.gridNumber = bubble2GridNumber;
        bubble2.gridNumber = bubble1GridNumber;
        
        [cell1 setBubble: bubble2];
        [cell2 setBubble: bubble1];
        
        NSArray *vMatches1 = [self getVerticalMatchesForCell:cell1 ];
        NSArray *hMatches1 = [self getHorizontalMatchesForCell:cell1 ];
        NSArray *vMatches2 = [self getVerticalMatchesForCell:cell2 ];
        NSArray *hMatches2 = [self getHorizontalMatchesForCell:cell2 ];
        
        if ([vMatches2 count] < 2 && [hMatches2 count] < 2 && [vMatches1 count] < 2 && [hMatches1 count] < 2) {
            [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
                bubble1.gridNumber = bubble1GridNumber;
                bubble2.gridNumber = bubble2GridNumber;
                
                [cell1 setBubble: bubble1];
                [cell2 setBubble: bubble2];
            } inReverse:YES];
        }
    } inReverse:NO];
}

- (void) bubbleSwap: (NSDictionary *) data
{
    Bubble *bubble = [data objectForKey:@"bubble"];
    DragDirection direction = [[data valueForKey:@"direction"] intValue];
    
    Bubble *bubble1 = bubble;
    
    GameGridCell *cell1 =  [self cellOnGrid:bubble1.gridNumber atPosition:bubble1.cellPosition];
   
    CGPoint newPosition;
    switch (direction) {
        case kDirectionDown:
            newPosition = CGPointMake(cell1.position.x, cell1.position.y-1);
            break;
        
        case kDirectionUp:
            newPosition = CGPointMake(cell1.position.x, cell1.position.y+1);
            break;
        
        case kDirectionLeft:
            newPosition = CGPointMake(cell1.position.x+1, cell1.position.y);
            break;

        case kDirectionRight:
            newPosition = CGPointMake(cell1.position.x-1, cell1.position.y);
            break;
            
        default:
            break;
    }
    
    if (newPosition.x >= 0 && newPosition.y >=0 && newPosition.x <= gameGridSizeWidth && newPosition.y <= gameGridSizeHeight){
        GameGridCell *cell2 = [self cellOnGrid:bubble1.gridNumber atPosition:newPosition];
    
        Bubble *bubble2 = cell2.bubble;
        
        CGPoint cell1Position = bubble1.cellPosition;
        CGPoint cell2Position = bubble2.cellPosition;
        
        [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
            
            bubble1.cellPosition = cell2Position;
            bubble2.cellPosition = cell1Position;
            
            [cell1 setBubble: bubble2];
            [cell2 setBubble: bubble1];
            
            NSArray *vMatches1 = [self getVerticalMatchesForCell:cell1 ];
            NSArray *hMatches1 = [self getHorizontalMatchesForCell:cell1 ];
            NSArray *vMatches2 = [self getVerticalMatchesForCell:cell2 ];
            NSArray *hMatches2 = [self getHorizontalMatchesForCell:cell2 ];
            
            if ([vMatches2 count] < 2 && [hMatches2 count] < 2 && [vMatches1 count] < 2 && [hMatches1 count] < 2) {
                [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
                    bubble1.cellPosition = cell1Position;
                    bubble2.cellPosition = cell2Position;
                    
                    [cell1 setBubble: bubble1];
                    [cell2 setBubble: bubble2];
                    
                } inReverse:YES];
            }
        } inReverse:NO];
    }
}

@end
