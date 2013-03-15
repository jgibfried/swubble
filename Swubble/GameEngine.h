//
//  GameEngine.h
//  Swubble
//
//  Created by John Gibfried on 3/12/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameEngine : NSObject

@property (nonatomic, strong) GameObject *currentGame;

- (GameObject *) getNewGame;

@end
