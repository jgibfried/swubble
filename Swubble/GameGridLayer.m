//
//  GameGridLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/11/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameGridLayer.h"

@implementation GameGridLayer

@synthesize windowSize;

-(id) init
{
    self = [super init];
	if(self) {
        [self setupGameGrid];
        [self drawScoreLabels];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScores) name:@"ScoreUpdated" object:nil];

    }
	return self;
}

- (void) drawScoreLabels
{
    self.windowSize = [[CCDirector sharedDirector] winSize];
    
    self.totalScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", self.game.totalScore] fontName:@"Helvetica" fontSize:36.0];
    self.totalScoreLabel.position = CGPointMake(120, self.windowSize.height-50);
    
    self.score1Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [self.game getScoreForType:@"1"]] fontName:@"Helvetica" fontSize:36.0];
    self.score1Label.position = CGPointMake(300, self.windowSize.height-50);
    
    self.score2Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [self.game getScoreForType:@"2"]] fontName:@"Helvetica" fontSize:36.0];
    self.score2Label.position = CGPointMake(500, self.windowSize.height-50);
    
    self.score3Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [self.game getScoreForType:@"3"]] fontName:@"Helvetica" fontSize:36.0];
    self.score3Label.position = CGPointMake(700, self.windowSize.height-50);
    
    [self addChild: self.totalScoreLabel];
    [self addChild: self.score1Label];
    [self addChild: self.score2Label];
    [self addChild: self.score3Label];
}

- (void) refreshScores
{
    [self.totalScoreLabel setString:[NSString stringWithFormat:@"%d", self.game.totalScore]];
    [self.score1Label setString:[NSString stringWithFormat:@"%d", [self.game getScoreForType:@"1"]]];
    [self.score2Label setString:[NSString stringWithFormat:@"%d", [self.game getScoreForType:@"2"]]];
    [self.score3Label setString:[NSString stringWithFormat:@"%d", [self.game getScoreForType:@"3"]]];
}

- (void) setupGameGrid
{
    GameObject *game = [[GameObject alloc] init];
    game.gameGridLayer = self;
    
    self.game = game;
    [self.game drawGridsAtOrigin:CGPointMake(gameGridOffsetX, gameGridOffsetY)];
}


- (void) dealloc
{
	[super dealloc];
}


@end
