//
//  SameEndScene.m
//  Swubble
//
//  Created by John Gibfried on 1/18/14.
//  Copyright (c) 2014 gibfried. All rights reserved.
//

#import "GameEndLayer.h"
#import "GameEndScene.h"

@implementation GameEndScene

+ (CCScene *) initWithScore: (int) totalScore
{
    return [BaseScene sceneWithLayers:[NSArray arrayWithObjects:[[GameEndLayer alloc] initWithScore: totalScore], nil]];;
}

@end
