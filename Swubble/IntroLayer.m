//
//  IntroLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright gibfried 2013. All rights reserved.
//


#import "IntroLayer.h"
#import "MenuScene.h"

@implementation IntroLayer

-(id) init
{
	if( (self=[super init])) {

		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background = [CCSprite spriteWithFile: introBackground];
		background.position = ccp(size.width/2, size.height/2);
		[self addChild: background z:0];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuScene init] ]];
}
@end
