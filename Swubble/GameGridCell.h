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
@property (nonatomic, strong) Bubble *bubble;

@end
