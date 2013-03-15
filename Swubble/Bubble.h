//
//  Bubble.h
//  Swubble
//
//  Created by John Gibfried on 3/14/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface Bubble : NSObject

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, strong) NSArray *colors;

+ (Bubble *) getNewBubble;

@end
