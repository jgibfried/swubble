//
//  GameScene.m
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

+ (CCScene *) init
{
    return [BaseScene sceneWithLayers:[NSArray arrayWithObjects:[[GameGridLayer alloc] init], nil]];;
}

@end
