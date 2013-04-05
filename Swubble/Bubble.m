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

@synthesize type;

@synthesize cellPosition;
@synthesize touchDelegate;
@synthesize gridNumber;

BOOL dragged = NO;
CGPoint startLocation;

-(id) initWithData: (NSDictionary *) data
{
    NSString *_file = [data objectForKey:@"file"];
    NSString *_type = [data objectForKey:@"type"];
    self = [super initWithFile: _file];
	if(self) {
        self.type = _type;
        self.bubbleId = [self newUUID];
    }
	return self;
}

+ (Bubble *) initWithData: (NSDictionary *) data
{
    return [[Bubble alloc] initWithData:data];
}

- (CGRect)boundingBoxInPixels
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
    
    dragged = NO;
    startLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.touchDelegate == nil) return;
    if (!dragged) {
        [self.touchDelegate performSelector:@selector(bubbleSwitchGrid:) withObject:self];
 	}
    dragged = NO;
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    CGFloat distance = [self distanceBetweenPoint:startLocation andPoint:currentLocation];
    if (distance >= gameBubbleDragDistance && !dragged) {
        dragged = YES;
        DragDirection direction = [self determineDirection:startLocation andEnd:currentLocation];
        
        NSArray *objects = [NSArray arrayWithObjects: self, [NSNumber numberWithInt: direction], nil];
        NSArray *keys = [NSArray arrayWithObjects: @"bubble", @"direction", nil];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        [self.touchDelegate performSelector:@selector(bubbleSwap:) withObject:info];
    }
}

-(CGFloat) distanceBetweenPoint: (CGPoint) point1 andPoint: (CGPoint) point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

-(DragDirection) determineDirection: (CGPoint) start andEnd: (CGPoint) end
{
    DragDirection direction;
    int dx = start.x - end.x;     // calculate change in x since start touch
    int dy = start.y - end.y;      // calculate change in y since start touch
    if (fabs(dx) > fabs(dy)) {
        if (dx>0) {
            direction = kDirectionRight;
        } else {
            direction = kDirectionLeft;
        }
    } else {
        if (dy>0) {
            direction = kDirectionDown;
        } else {
            direction = kDirectionUp;
        }
    }
    
    return direction;
}

- (NSString *) newUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = ( NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}

@end
