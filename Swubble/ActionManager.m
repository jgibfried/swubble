//
//  ActionManager.m
//  Swubble
//
//  Created by John Gibfried on 4/5/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "ActionManager.h"

@implementation ActionManager

-(id) initWithTarget: (CCLayer *) target
{
    self = [super init];
	if(self) {
        self.actionList = [NSMutableArray array];
        self.target = target;
    }
	return self;
}

- (void) addAction: (id) action
{
    [self.actionList addObject:action];
}

- (void) clearActionList
{
    [self.actionList removeAllObjects];
}

- (void) runActions: (NSString *) type
{
    if ([self.actionList count]) {
        CCFiniteTimeAction *actionSeq;
        if ([type isEqualToString:@"spawn"]) {
            actionSeq = [self getActionSpawn:self.actionList];
        } else {
            actionSeq = [self getActionSequence:self.actionList];
        }
        [self.target runAction: actionSeq];
        [self clearActionList];
    }
}

-(CCFiniteTimeAction *) getActionSequence: (NSArray *) actions
{
	CCFiniteTimeAction *seq = nil;
	for (CCFiniteTimeAction *anAction in actions)
	{
		if (!seq)
		{
			seq = anAction;
		}
		else
		{
			seq = [CCSequence actionOne:seq two:anAction];
		}
	}
	return seq;
}


-(CCFiniteTimeAction *) getActionSpawn: (NSArray *) actions
{
    CCFiniteTimeAction *result = nil;
    for (CCFiniteTimeAction *anAction in actions)
    {
        if (!result)
        {
            result = anAction;
        }
        else
        {
            result = [CCSpawn actionOne:result two:anAction];
        }
    }
    return result;
}

@end
