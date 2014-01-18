//
//  GameEndLayer.m
//  Swubble
//
//  Created by John Gibfried on 5/14/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameScene.h"
#import "GameEndLayer.h"

@implementation GameEndLayer

-(id) initWithScore: (int) totalScore
{
    self = [super init];
	if(self) {
        self.totalScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Total: %d", totalScore] fontName:@"Helvetica" fontSize:26.0];
        self.totalScoreLabel.color = whiteColor;
        self.totalScoreLabel.position = CGPointMake(self.windowSize.width/2, self.windowSize.height/2);
        
        [CCMenuItemFont setFontName:@"Helvetica"];
        [CCMenuItemFont setFontSize:26];
        CCMenuItem *startGameItem = [CCMenuItemFont itemWithString:@"RESTART" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene init] ]];
        }];
        [startGameItem setColor:whiteColor];
        
        CCMenu *menu = [CCMenu menuWithItems:startGameItem, nil];
        
        [menu alignItemsVerticallyWithPadding:20];
        [menu setPosition:ccp( self.totalScoreLabel.position.x, self.totalScoreLabel.position.y-30)];
        
        [self addChild: self.totalScoreLabel];
        [self addChild:menu z:1];

    }
	return self;
}

- (void) restartGame {
    
}

@end
