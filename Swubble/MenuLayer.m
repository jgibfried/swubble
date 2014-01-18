//
//  MenuLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright gibfried 2013. All rights reserved.
//


#import "GameScene.h"
#import "MenuLayer.h"

@implementation MenuLayer

-(id) init
{
	if( (self=[super init]) ) {
        [self setupMenu];
	}
	return self;
}

- (void) setupMenu
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Swubble" fontName:@"Helvetica" fontSize:40];
    
    label.color = whiteColor;
    
    label.position =  ccp( self.windowSize.width /2 , self.windowSize.height/2 );
    [self addChild: label];
    
    [CCMenuItemFont setFontName:@"Helvetica"];
    [CCMenuItemFont setFontSize:28];
    CCMenuItem *startGameItem = [CCMenuItemFont itemWithString:@"Start Game" block:^(id sender) {
    	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene init] ]];
    }];
    [startGameItem setColor:whiteColor];
    
    CCMenu *menu = [CCMenu menuWithItems:startGameItem, nil];
    
    [menu alignItemsVerticallyWithPadding:20];
    [menu setPosition:ccp( self.windowSize.width/2, self.windowSize.height/2 - 50)];
    
    // Add the menu to the layer
    [self addChild:menu z:1];
}

- (void) dealloc
{
	[super dealloc];
}

@end