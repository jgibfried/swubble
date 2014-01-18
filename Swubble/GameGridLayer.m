//
//  GameGridLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/11/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameGridLayer.h"

@implementation GameGridLayer

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
    self.totalScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total: %d", self.game.totalScore] fontName:@"Helvetica" fontSize:26.0];
    self.totalScoreLabel.color = whiteColor;
    self.totalScoreLabel.position = CGPointMake(100, self.windowSize.height-50);
    
    self.score1Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Y: %d", [self.game getScoreForType:@"1"]] fontName:@"Helvetica" fontSize:26.0];
    self.score1Label.color = whiteColor;
    self.score1Label.position = CGPointMake(200, self.windowSize.height-50);
    
    self.score2Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"G: %d", [self.game getScoreForType:@"2"]] fontName:@"Helvetica" fontSize:26.0];
    self.score2Label.color = whiteColor;
    self.score2Label.position = CGPointMake(300, self.windowSize.height-50);
    
    self.score3Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"R: %d", [self.game getScoreForType:@"3"]] fontName:@"Helvetica" fontSize:26.0];
    self.score3Label.color = whiteColor;
    self.score3Label.position = CGPointMake(400, self.windowSize.height-50);
    
    self.score4Label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"B: %d", [self.game getScoreForType:@"4"]] fontName:@"Helvetica" fontSize:26.0];
    self.score4Label.color = whiteColor;
    self.score4Label.position = CGPointMake(500, self.windowSize.height-50);
    
    [self addChild: self.totalScoreLabel];
    [self addChild: self.score1Label];
    [self addChild: self.score2Label];
    [self addChild: self.score3Label];
    [self addChild: self.score4Label];
}

- (void) refreshScores
{
    [self.totalScoreLabel setString:[NSString stringWithFormat:@"Total: %d", self.game.totalScore]];
    [self.score1Label setString:[NSString stringWithFormat:@"Y: %d", [self.game getScoreForType:@"1"]]];
    [self.score2Label setString:[NSString stringWithFormat:@"G: %d", [self.game getScoreForType:@"2"]]];
    [self.score3Label setString:[NSString stringWithFormat:@"R: %d", [self.game getScoreForType:@"3"]]];
    [self.score4Label setString:[NSString stringWithFormat:@"B: %d", [self.game getScoreForType:@"4"]]];
}

- (void) setupGameGrid
{
    GameObject *game = [[GameObject alloc] init];
    game.gameGridLayer = self;
   
    self.game = game;
    [self.game drawGridsAtOrigin:CGPointMake(gameGridOffsetX, gameGridOffsetY)];
    [self.game startGame];
}


- (void) dealloc
{
	[super dealloc];
}


@end
