//
//  ActionManager.h
//  Swubble
//
//  Created by John Gibfried on 4/5/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bubble.h"

@interface ActionManager : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSMutableArray *actionList;
@property (nonatomic, strong) CCLayer *target;

- (void) addAction: (id) action;

-(id) initWithTarget: (CCLayer *) target;
- (void) runActions: (NSString *) type;
- (void) clearActionList;

@end
