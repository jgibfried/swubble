//
//  GameGrid.h
//  Swubble
//
//  Created by John Gibfried on 3/16/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "cocos2d.h"
#import "GameGridCell.h"

@interface GameGrid : NSObject

@property (nonatomic, strong) NSArray *grid;
@property (nonatomic) CGPoint layerOrigin;

+(GameGrid *) initWithDimensions: (CGPoint) dimensions;

- (void) drawGridAtOrigin: (CGPoint) origin onLayer: (CCLayer *)layer;

-(id) initWithDimensions: (CGPoint) dimensions;

- (GameGridCell *) getCellForPosition: (CGPoint)position;
- (NSMutableArray *) getColumnForPosition: (CGPoint)position;

@end
