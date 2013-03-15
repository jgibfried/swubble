//
//  GameObject.h
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameObject : NSObject

@property (nonatomic) int totalBonuses;
@property (nonatomic) int totalScore;

@property (nonatomic) int difficultyLevel;

@property (nonatomic) int gameTimeSpent;
@property (nonatomic) int gameTimeLeft;

@property (nonatomic, strong) NSTimer *gameTimer;

- (GameObject *) startGame;

@end
