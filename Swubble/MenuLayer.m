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
    CGSize size = [[CCDirector sharedDirector] winSize];
//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Swubble!" fontName:@"Helvetica" fontSize:28];
//    
//    label.color = ccc3(0, 0, 0);
//    
//    label.position =  ccp( size.width /2 , size.height/2 );
//    [self addChild: label];
    
    [CCMenuItemFont setFontSize:28];
    CCMenuItem *startGameItem = [CCMenuItemFont itemWithString:@"Start Game" block:^(id sender) {
    	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene init] ]];
    }];
    [startGameItem setColor:ccc3(0,0,0)];
    
    CCMenu *menu = [CCMenu menuWithItems:startGameItem, nil];
    
    [menu alignItemsVerticallyWithPadding:20];
    [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
    
    // Add the menu to the layer
    [self addChild:menu z:1];
}

- (void) dealloc
{
	[super dealloc];
}

@end