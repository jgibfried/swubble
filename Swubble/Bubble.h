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

@interface Bubble : CCSprite <CCTouchOneByOneDelegate> {
    id touchDelegate;
}
@property (nonatomic) int bubbleId;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) id touchDelegate;
@property (nonatomic, readonly) CGRect boundingBox;
@property (nonatomic) CGPoint cellPosition;
@property (nonatomic) int gridNumber;

+ (Bubble *) initWithData: (NSDictionary *) data;

@end
