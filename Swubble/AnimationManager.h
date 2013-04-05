//
//  AnimationManager.h
//  Swubble
//
//  Created by John Gibfried on 4/5/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bubble.h"

@interface AnimationManager : NSObject

@property (nonatomic, strong) Bubble *bubble;
@property (nonatomic, strong) NSMutableArray *actionList;

- (void) addAction: (id) action;
- (void) clearActionList;

@end
