//
//  GameGridCell.h
//  Swubble
//
//  Created by John Gibfried on 3/16/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Bubble.h"

@interface GameGridCell : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGPoint bubblePosition;
@property (nonatomic, strong) Bubble *bubble;
@property (nonatomic) int gridNumber;


@end
