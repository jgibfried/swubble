//
//  GameGrid.m
//  Swubble
//
//  Created by John Gibfried on 3/16/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameGrid.h"

@implementation GameGrid

@synthesize grid;
@synthesize layerOrigin;

+(GameGrid *) initWithDimensions: (CGPoint) dimensions
{
    GameGrid *gameGrid = [[GameGrid alloc] initWithDimensions: dimensions];
    
    return gameGrid;
}

- (id) initWithDimensions:  (CGPoint) dimensions
{
    if( (self=[super init]) ) {
        self.grid = [self getNewGrid: dimensions];
    }
	return self;
}

- (NSMutableArray *) getNewGrid: (CGPoint) dimensions
{
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    for (int i=0; i<=dimensions.x; i++) {
        // insert row
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<=dimensions.y; j++) {
            GameGridCell *newGridCell = [[GameGridCell alloc] init];
            newGridCell.position = CGPointMake(i, j);
            [row insertObject:newGridCell atIndex:j];
        }
        [columns insertObject:row atIndex:i];
    }
    return columns;
}

- (void) drawGridAtOrigin: (CGPoint) origin onLayer: (CCLayer *)layer
{
    __block float xPosition = origin.x;
    __block float yPosition = origin.y;
    
    CCSprite *pen = [CCSprite spriteWithFile:borderBackground];
    pen.position =  ccp((xPosition-gameGridCellWidth)+(pen.contentSize.width/2), (yPosition-gameGridCellHeight-25)+(pen.contentSize.height/2));
    
    [layer addChild:pen z:0];
    
    for(NSMutableArray *column in self.grid)
    {
        for (GameGridCell *cell in column)
        {
            cell.bubblePosition = ccp(xPosition, yPosition);
            cell.bubble.position = ccp(xPosition, yPosition);
            [layer addChild: cell.bubble z: 3];
            yPosition = (yPosition + gameGridCellHeight);
        }
        yPosition = origin.y;
        xPosition = (xPosition + gameGridCellWidth);
    }
}

- (GameGridCell *) getCellForPosition: (CGPoint)position
{
    NSMutableArray *row = [self.grid objectAtIndex: position.x];
    return [row objectAtIndex:position.y];
}


- (NSMutableArray *) getColumnForPosition: (CGPoint)position
{
    return [self.grid objectAtIndex: position.x];
}


@end
