//
//  BaseScene.m
//  Swubble
//
//  Created by John Gibfried on 3/6/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "BaseScene.h"

@implementation BaseScene

+(CCScene *) sceneWithLayers: (NSArray *) layers
{
	CCScene *scene = [CCScene node];
	
    [layers enumerateObjectsUsingBlock:^(id layer, NSUInteger idx, BOOL *stop) {
        [scene addChild: layer];
	}];
	
	// return the scene
	return scene;
}

@end
