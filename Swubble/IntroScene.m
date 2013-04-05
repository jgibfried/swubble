//
//  IntroScene.m
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "IntroScene.h"

@implementation IntroScene

+ (CCScene *) init
{
    return [BaseScene sceneWithLayers:[NSArray arrayWithObjects:[[IntroLayer alloc] init], nil]];
}

@end
