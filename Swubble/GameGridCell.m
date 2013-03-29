//
//  GameGridCell.m
//  Swubble
//
//  Created by John Gibfried on 3/16/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "GameGridCell.h"

@implementation GameGridCell

@synthesize gridNumber;
@synthesize bubblePosition;
@synthesize bubble = _bubble;


- (void) setBubble:(Bubble *)b
{
    if (b != nil) {
        b.cellPosition = self.position;
        b.gridNumber = self.gridNumber;
    }
    _bubble = b;
}

@end
