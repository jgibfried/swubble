//
//  GameObject.h
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameGrid.h"
#import "Bubble.h"

@interface GameObject : NSObject


@property (nonatomic, strong) CCLayer *gameGridLayer;

@property (nonatomic, strong) NSArray *bubbleTypes;
@property (nonatomic, strong) NSMutableSet *matchesToDestroy;

@property (nonatomic) int totalBonuses;
@property (nonatomic) int totalScore;

@property (nonatomic) int difficultyLevel;

@property (nonatomic) int gameTimeSpent;
@property (nonatomic) int gameTimeLeft;

@property (nonatomic, strong) NSArray *grids;

@property (nonatomic, strong) NSTimer *gameTimer;

- (void)startGame;
- (void)populateGrids;
- (void)drawGridsAtOrigin: (CGPoint) origin;

@end
