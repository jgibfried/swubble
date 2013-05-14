//
//  BaseLayer.m
//  Swubble
//
//  Created by John Gibfried on 3/7/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "BaseLayer.h"

@implementation BaseLayer


-(id) init
{
    self = [super init];
	if(self) {
        self.windowSize = [[CCDirector sharedDirector] winSize];
    }
	return self;
}


@end
