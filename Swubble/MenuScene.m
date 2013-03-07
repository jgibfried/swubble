//
//  MenuScene.m
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene

+ (CCScene *) init
{
    return [BaseScene sceneWithLayers:[[NSArray alloc] initWithObjects:[[MenuBackgroundLayer alloc] init], [[MenuLayer alloc] init], nil]];
}

@end
