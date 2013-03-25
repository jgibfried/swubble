//
//  Bubble.m
//  Swubble
//
//  Created by John Gibfried on 3/14/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

@synthesize bubbleId;

@synthesize cellPosition;
@synthesize touchDelegate;
@synthesize gridNumber;

-(id) initWithFile: (NSString *) file
{
	if( (self=[super initWithFile:file]) ) {

    }
	return self;
}

+ (Bubble *) initWithFile: (NSString *) file
{
    return [[Bubble alloc] initWithFile:file];
}

- (CGRect)boundingBoxInPixels
{
    CGSize s = [self.texture contentSizeInPixels];
    return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (CGRect)boundingBox
{
    CGSize s = [self.texture contentSize];
    return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}


- (BOOL)containsTouchLocation:(UITouch *)touch
{
    return CGRectContainsPoint(self.boundingBoxInPixels, [self convertTouchToNodeSpaceAR:touch]);
}

- (void)onEnter
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}


- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self ];
    [super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( ![self containsTouchLocation:touch] ) return NO;
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.touchDelegate == nil) return;
    [self.touchDelegate performSelector:@selector(bubbleSwitchGrid:) withObject:self];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
