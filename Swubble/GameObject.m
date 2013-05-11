//
//  GameObject.m
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

int maxCount = 0;

- (id)init
{
    if( (self=[super init]) ) {
        self.gameTimeLeft = gameTimeDefault;
        self.grids = [NSArray arrayWithObjects:[GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)], [GameGrid initWithDimensions:CGPointMake(gameGridSizeWidth, gameGridSizeHeight)], nil];
        self.matchesToDestroy = [NSMutableSet set];
        self.windowSize = [[CCDirector sharedDirector] winSize];
        
        self.score = [NSMutableDictionary dictionary];
        for (NSDictionary *bubbleType in self.bubbleTypes) {
            [self.score setValue:[NSNumber numberWithInt:0] forKey:[bubbleType objectForKey:@"type"]];
        }
    }
	return self;
}

- (void)startGame
{
    [self startTimeClock];
}


- (void)startTimeClock
{
    self.gameTimeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time Left: %d", self.gameTimeLeft] fontName:@"Helvetica" fontSize:30.0];
    self.gameTimeLabel.position = CGPointMake(self.windowSize.width-120, self.windowSize.height-50);
    [self.gameGridLayer addChild: self.gameTimeLabel];
    
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(second:)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)second:(NSTimer *)timer
{
    self.gameTimeSpent++;
    self.gameTimeLeft--;
    
    [self.gameTimeLabel setString:[NSString stringWithFormat:@"Time Left: %d", self.gameTimeLeft]];
    
    if (self.gameTimeLeft <= 0)
        [self endGame];
}

- (void) endGame
{
    
    [self.gameTimer invalidate];
}

- (void) incrementScore: (int) amount forType: (NSString *) type
{
    int newScore = ([[self.score objectForKey:type] integerValue] + amount);
    [self.score setValue:[NSNumber numberWithInt:newScore] forKey:type];
}

- (int) getTotalScore
{
    int totalScore = 0;
    for (NSDictionary *type in self.bubbleTypes) {
        totalScore += [[self.score objectForKey:[type objectForKey:@"type"]] integerValue];
    }
    return totalScore;
}

- (int) getScoreForType: (NSString *)type
{
    return [[self.score objectForKey:type] integerValue];
}

/* Bubble Utility Methods ******************************/

- (NSArray *) bubbleTypes
{
    NSDictionary *type1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", pigSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", cowSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type3 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"3", chickenSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type4 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"4", redBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    NSDictionary *type5 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"5", greenBubbleSprite, nil] forKeys:[NSArray arrayWithObjects:@"type", @"file", nil]];
    
    return [NSArray arrayWithObjects: type1, type2, type3, type4, type5, nil];
}

- (Bubble *) getNewBubble
{
    int randomNumber = ((arc4random() % [self.bubbleTypes count]) + 1) - 1  ;
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
    __block float xPosition = origin.x;
    __block float yPosition = origin.y;
    
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger gridIdx, BOOL *stop) {
        CCSprite *pen = [CCSprite spriteWithFile:penBackground];
        pen.position =  ccp((xPosition-gameGridCellWidth)+(pen.contentSize.width/2), (yPosition-gameGridCellHeight-25)+(pen.contentSize.height/2));
        
        [self.gameGridLayer addChild:pen z:0];

        for(NSMutableArray *column in grid.grid)
        {
            for (GameGridCell *cell in column)
            {
                cell.bubblePosition = ccp(xPosition, yPosition);
                cell.bubble.position = ccp(xPosition, yPosition);
                [self.gameGridLayer addChild: cell.bubble z: 3];
                yPosition = (yPosition + gameGridCellHeight);
            }
            yPosition = origin.y;
            xPosition = (xPosition + gameGridCellWidth);
        }
        xPosition = (xPosition + gameGridCellWidth);
    }];
    
    [self.gameGridLayer runAction: [CCSequence actions:
                                    [CCDelayTime actionWithDuration: 1],
                                    [CCCallFunc actionWithTarget:self selector:@selector(check)],
                                    nil]];

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

- (void) setColumnLock: (BOOL) locked atPosition: (CGPoint) position
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        [[grid getColumnForPosition:position] enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
            cell.bubble.locked = locked;
        }];
    }];
}

- (void) setBubbleLock: (Bubble *) bubble toValue:(BOOL) locked
{
    bubble.locked = locked;
    GameGridCell *otherCell = [self cellOnGrid:[self oppositeGridNumber:bubble.gridNumber] atPosition:bubble.cellPosition];
    otherCell.bubble.locked = locked;
}

- (void) setAllGridsLock: (BOOL) locked
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        [self setGrid:idx toLock:locked];
    }];
}

- (void) setGrid:(int) gridNumber toLock: (BOOL) locked
{
    [((GameGrid *)[self.grids objectAtIndex:gridNumber]).grid enumerateObjectsUsingBlock:^(NSMutableArray *column, NSUInteger idx, BOOL *stop) {
        [column enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
            cell.bubble.locked = locked;
        }];
    }];
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

- (int) getPoints
{
    int points = pointsPerBubble;
    if ([self.matchesToDestroy count] > 3) {
        points = 3;
    }
    if ([self.matchesToDestroy count] > 5) {
        points += 5;
    }
    if ([self.matchesToDestroy count] > 10) {
        points += 8;
    }
    return points;
}

- (BOOL) check
{
	[self checkForMatches];
	
	NSArray *objects = [[self.matchesToDestroy objectEnumerator] allObjects];
	if ([objects count] == 0) {
        [self setAllGridsLock:NO];
        return NO;
	}
	
    int points = [self getPoints];
    
    NSMutableArray *actionArray = [NSMutableArray array];
    
    for (GameGridCell *cell in self.matchesToDestroy) {
        [self setGrid:cell.gridNumber toLock:YES];
        if (cell.bubble) {
            Bubble *bubble = cell.bubble;
            cell.bubble = nil;
            
            [self incrementScore:points forType:bubble.type];
            
            [actionArray addObject:[CCCallBlock actionWithBlock:^(void){
                                        [bubble runAction:[CCScaleTo actionWithDuration:bubbleDestroyTime scale:0.0]];
                                        [bubble runAction:[CCCallFuncN actionWithTarget: self selector:@selector(removeBubble:)]];
                                    }]];
            
        }
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ScoreUpdated" object:self]];
	[self.matchesToDestroy removeAllObjects];
    
    [actionArray addObject:[CCDelayTime actionWithDuration: 0.33]];
    [actionArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(fillEmptyCells)]];
    [actionArray addObject:[CCDelayTime actionWithDuration: bubblePopulateTime]];
    [actionArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(afterAllMoveDone)]];
    
    CCFiniteTimeAction *actionSeq = [self getActionSequence:actionArray];
    
    [self.gameGridLayer runAction: actionSeq];
    
    [actionArray removeAllObjects];
    return YES;
}

- (void) removeBubble: (id) sender
{
    [self.gameGridLayer removeChild: sender cleanup:YES];
}

- (void) afterAllMoveDone{
    [self check];
}

- (void) checkForMatches
{
    [self.grids enumerateObjectsUsingBlock:^(GameGrid *grid, NSUInteger idx, BOOL *stop) {
        [grid.grid enumerateObjectsUsingBlock:^(NSMutableArray *column, NSUInteger idx, BOOL *stop) {
            [column enumerateObjectsUsingBlock:^(GameGridCell *cell, NSUInteger idx, BOOL *stop) {
                NSArray *matches1 = [self getMatches:cell];
                
                NSArray *vMatches1 = [matches1 objectAtIndex:0];
                NSArray *hMatches1 = [matches1 objectAtIndex:1];
                
                if ([vMatches1 count] >= 3) {
                    for (GameGridCell *cell in vMatches1) {
                        [self setBubbleLock:cell.bubble toValue:YES];
                    }
                    [self.matchesToDestroy addObjectsFromArray:vMatches1];
                }
                if ([hMatches1 count] >= 3) {
                    for (GameGridCell *cell in hMatches1) {
                        [self setBubbleLock:cell.bubble toValue:YES];
                    }
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
                bubble = [self addNewBubbleAtPosition:CGPointMake(cell.bubblePosition.x, self.windowSize.height+gameGridCellHeight)];
                bubble.gridNumber = cell.gridNumber;
                bubble.locked = YES;
            } else {
                bubble = cellToCheck.bubble;
                [cellToCheck setBubble:nil];
            }
            
            NSMutableArray *actionArray = [NSMutableArray array];
            
            [actionArray addObject:[CCMoveTo actionWithDuration:bubblePopulateTime position:ccp(cell.bubblePosition.x, cell.bubblePosition.y)]];
            [actionArray addObject:[CCRotateBy actionWithDuration:bubblePopulateTime angle:[self randFloatBetween:0.1 and:360.0]]];
            
            CCFiniteTimeAction *actionSeq = [self getActionSpawn:actionArray];
            
            [bubble runAction: actionSeq];
            
            [cell setBubble: bubble];
        }
    }];
    return extension;
}

/* Bubble Movement ******************************/

- (void) bubbleSwitchGrid:(Bubble *) bubble {

    Bubble *bubble1 = bubble;
    
    if (bubble1.locked) {
        return;
    }
    
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
    
    if (bubble1.locked) {
        return;
    }
    
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
    
    if ([self.matchesToDestroy containsObject:cell1] || [self.matchesToDestroy containsObject:cell2]) {
        return;
    }
    
    Bubble *bubble1 = cell1.bubble;
    if (!bubble1 || bubble1.locked) {
        return;
    }
    
    Bubble *bubble2 = cell2.bubble;
    if (!bubble2 || bubble2.locked) {
        return;
    }
    [self setGrid:bubble1.gridNumber toLock:YES];
    [self setGrid:bubble2.gridNumber toLock:YES];
    
    [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
        
        [cell2 setBubble: bubble1];
        [cell1 setBubble: bubble2];
        
        if ([self check] == NO) {
            [self animateSwap:cell1 withCell:cell2 withHandler:^(void){
                [cell1 setBubble: bubble1];
                [cell2 setBubble: bubble2];
                [self setGrid:bubble1.gridNumber toLock:NO];
                [self setGrid:bubble2.gridNumber toLock:NO];
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
                 //[CCRotateTo durationTime:1.0 angle:180.0]]
                 
                 [cell1.bubble runAction:[CCMoveTo actionWithDuration:bubbleSwapTime position:ccp(cell2BubblePosition.x, cell2BubblePosition.y)]];
                 [cell1.bubble runAction:[CCRotateBy actionWithDuration:bubbleSwapTime angle:45.0]];
                 
                 [cell2.bubble runAction:[CCMoveTo actionWithDuration:bubbleSwapTime position:ccp(cell1BubblePosition.x, cell1BubblePosition.y)]];
                 [cell2.bubble runAction:[CCRotateBy actionWithDuration:bubbleSwapTime angle:45.0]];
             }],
              [CCDelayTime actionWithDuration:(bubbleSwapTime*2)],
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

-(float) randFloatBetween:(float)low and:(float)high
{
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

-(CCFiniteTimeAction *) getActionSequence: (NSArray *) actions
{
	CCFiniteTimeAction *seq = nil;
	for (CCFiniteTimeAction *anAction in actions)
	{
		if (!seq)
		{
			seq = anAction;
		}
		else
		{
			seq = [CCSequence actionOne:seq two:anAction];
		}
	}
	return seq;
}


-(CCFiniteTimeAction *) getActionSpawn: (NSArray *) actions
{
    CCFiniteTimeAction *result = nil;
    for (CCFiniteTimeAction *anAction in actions)
    {
        if (!result)
        {
            result = anAction;
        }
        else
        {
            result = [CCSpawn actionOne:result two:anAction];
        }
    }
    return result;
}
        
@end
