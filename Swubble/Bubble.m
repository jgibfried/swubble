//
//  Bubble.m
//  Swubble
//
//  Created by John Gibfried on 3/14/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

@synthesize sprite;
@synthesize colors;

-(id) init
{
	if( (self=[super init]) ) {
        int randomNumber = (int) ((double)arc4random() / ARC4RANDOM_MAX);

        self.colors = [[NSArray alloc] initWithObjects:redBubbleSprite, greenBubbleSprite, nil];
        self.sprite = [[CCSprite alloc] initWithFile:[colors objectAtIndex:randomNumber]];
    }
	return self;
}

+ (Bubble *) getNewBubble
{
    return [[Bubble alloc] init];
}

@end
